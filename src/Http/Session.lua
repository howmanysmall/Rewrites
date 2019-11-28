-- Sessions
local Utility = require(script.Parent.Utility)
local Request = require(script.Parent.Request)
local CookieJar = require(script.Parent.Cookies)
local RateLimiter = require(script.Parent.RateLimit)
local RateLimitTable = require(script.Parent.RateLimitTable)
local StringPlus = Utility.StringPlus

local StringPlus_RandomString = StringPlus.RandomString
local StringPlus_TitleCase = StringPlus.TitleCase
local next = next
local ipairs = ipairs

local Session = {}
Session.__index = Session

function Session.new(base_url)
	return setmetatable({
		headers = {};
		cookies = CookieJar.new();
		base_url = base_url or "";
		_ratelimit = nil;
		ignore_ratelimit = false;
		before_request = nil;
		after_request = nil;
		log = true;
	}, Session)
end

function Session:SetRateLimit(rate, window)
	-- delete original ratelimiter
	if self._ratelimit then
		RateLimitTable[self._ratelimit.id] = nil
	end

	-- sets new session ratelimiter
	local rl_id = "http.session-" .. StringPlus_RandomString(12)
	self._ratelimit = RateLimiter.Get(rl_id, rate, window)
end

function Session:DisableRateLimit()
	-- disables session rate limit

	if self._ratelimit then
		RateLimitTable:Free(self._ratelimit.id)
		self._ratelimit = nil
	end
end

function Session:SetHeaders(headers)
	-- headers: (dictionary) additional headers to set
	for k, v in next, headers do
		self.headers[k] = v
	end

	return self
end

function Session:Request(method, url, opts)
	-- prepares request based on Session's default values, such as headers
	-- session defaults will NOT overwrite values set per-request
	opts = opts or {}

	-- add prefix if not absolute url
	if not StringPlus.StartsWith(url, "http://") or not StringPlus.StartsWith(url, "https://") then
		url = self.base_url .. url
	end

	-- prepare request based on session defaults
	local request = Request.new(method, url, {
		headers = self.headers,
		query = opts.query,
		data = opts.data,
		log = self.log or opts.log,
		cookies = opts.cookies or self.cookies,
		ignore_ratelimit = opts.ignore_ratelimit or self.ignore_ratelimit
	})

	if self._ratelimit then
		request._ratelimits[#request._ratelimits + 1] = self._ratelimit -- make request follow session ratelimit
	end

	request:UpdateHeaders(opts.headers or {})

	function request._callback(resp)
		for _, cookie in ipairs(resp.cookies.cookies) do
			self.cookies.cookies[#self.cookies.cookies + 1] = cookie
		end
	end

	return request
end

function Session:Send(method, url, opts)
	-- quick method to send http requests
	-- method: (str) HTTP Method
	-- url: (str) Fully qualified URL
	-- options (dictionary):
		-- headers: (dictionary) Headers to send with request
		-- query: (dictionary) Query string parameters
		-- data: (str OR dictionary) Data to send in POST or PATCH request
		-- log: (bool) Whether to log the request
		-- cookies: (CookieJar OR dict) Cookies to use in request

	opts = opts or {}
	return self:Request(method, url, opts):Send()
end

-- create quick functions for each http method
for _, method in ipairs{"GET", "POST", "HEAD", "OPTIONS", "PUT", "DELETE", "PATCH"} do
	Session[StringPlus_TitleCase(method)] = function(self, url, opts)
		return self:Send(method, url, opts)
	end
end

return Session