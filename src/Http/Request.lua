local HttpService = game:GetService("HttpService")

local Utility = require(script.Parent.Utility)
local Response = require(script.Parent.Response)
local CookieJar = require(script.Parent.Cookies)
local RateLimiter = require(script.Parent.RateLimit)

local Url = Utility.Url
local FastSpawn = Utility.FastSpawn

local Url_Parse = Url.Parse

local next = next
local ipairs = ipairs

local Request = {}
Request.__index = Request

function Request.new(method, url, opts)
	-- quick method to send http requests
	--  method: (str) HTTP Method
	--	 url: (str) Fully qualified URL
	-- options (dictionary):
		-- headers: (dictionary) Headers to send with request
		--   query: (dictionary) Query string parameters
		--	data: (str OR dictionary) Data to send in POST or PATCH request
		--	 log: (bool) Whether to log the request
		-- cookies: (CookieJar OR dict) Cookies to use in request
		-- ignore_ratelimit: (bool) If true, rate limiting is ignored. Not recommended unless you are rate limiting yourself.

	opts = opts or {}

	local u = Url_Parse(url)
	local headers = opts.headers or {}

	local self = setmetatable({
		method = method;
		url = u;
		headers = headers;
		query = {};
		data = nil;
		_ratelimits = {RateLimiter.Get("http", 250, 30)};
		ignore_ratelimit = opts.ignore_ratelimit or false;
	}, Request)

	if opts.data then
		self:SetData(opts.data)
	end

	self:UpdateQuery(opts.query or {})

	-- handle cookies

	local cj = opts.cookies or {}
	if not cj.__cookiejar then  -- check if CookieJar was passed. if not, convert to CookieJar
		local jar = CookieJar.new()

		if cj then
			for k, v in next, cj do
				jar:Insert(k, v)
			end
		end

		cj = jar
	end

	self.cookies = cj
	self.headers.Cookie = cj:String(url)

	self._callback = nil
	self._log = opts.log or true
	return self
end

function Request:UpdateHeaders(headers)
	-- headers: (dictionary) additional headers to set
	for k, v in next, headers do
		self.headers[k] = v
	end

	return self
end

function Request:UpdateQuery(params)
	-- params: (dictionary) additional query string parameters to set
	for k, v in next, params do
		self.query[k] = v
	end

	self.url:SetQuery(self.query) -- update url
	return self
end

function Request:SetData(data)
	-- sets request data (string or table)
	if type(data) == "table" then
		if data.__FormData then
			self.headers["Content-Type"] = data.content_type
			data = data:Build()
		else
			data = HttpService:JSONEncode(data)
			self.headers["Content-Type"] = "application/json"
		end
	end

	self.data = data
end

function Request:_ratelimit()
	-- checks all ratelimiters assigned to request
	for _, rl in ipairs(self._ratelimits) do
		if not rl:Request() then
			return false
		end
	end

	return true
end

function Request:_send()
	-- prepare request options
	local options = {
		Url = self.url:Build();
		Method = self.method;
		Headers = self.headers;
	}

	if self.data ~= nil then
		options.Body = self.data
	end

	local attempts = 0
	local succ, resp = false, nil

	while attempts < 5 do
		-- check if request will exceed rate limit
		if self.ignore_ratelimit or self:_ratelimit() then
			local st = tick()
			resp = Response.new(self, HttpService:RequestAsync(options), tick() - st)
			succ = true
			break
		end

		warn("[Http] Rate limit exceeded. Retrying in 5 seconds")

		attempts = attempts + 1
		wait(5)
	end

	if not succ then
		error("[Http] Rate limit still exceeded after 5 attempts")
	end

	if self._log then
		local rl = tostring(math.floor(self._ratelimits[#self._ratelimits]:Consumption() * 1000) / 10) .. "%"
		print("[Http]", resp.code, resp.message, "|", resp.method, resp.url, "(", rl, "ratelimit )")
	end

	if self._callback then
		self._callback(resp)
	end

	return resp
end

function Request:Send(cb)
	-- send request via HttpService and return Response object
	-- if a callback function is specified, the request will be executed asynchronously and
	-- pass the return value to the callback. Otherwise, it is run blocking

	if cb then
		FastSpawn(cb, self:_send())
	else
		return self:_send()
	end
end

return Request