local HttpService = game:GetService("HttpService")
local CookieJar = require(script.Parent.Cookies)
local Utility = require(script.Parent.Utility)
local CaseInsensitive = Utility.CaseInsensitiveTable

local Response = {}
Response.__index = Response

function Response.new(req, resp, rt)
	local self = setmetatable({
		request = req; -- original request object
		response_time = rt;
		url = req.url;
		method = req.method;
		success = resp.Success;
		code = resp.StatusCode;
		message = resp.StatusMessage;
		headers = CaseInsensitive(resp.Headers);
		content = resp.Body;
		content_type = nil;
		content_length = nil;
		cookies = CookieJar.new();
	}, Response)

	-- additional metadata for quick access
	self.content_type = self.headers["content-type"]
	self.content_length = self.headers["content-length"] or #self.content

	if self.headers["set-cookie"] then
		self.cookies:SetCookie(self.headers["set-cookie"])
	end

	return self
end

function Response:__tostring()
	return self.content
end

function Response:Json()
	local succ, data = pcall(HttpService.JSONDecode, HttpService, self.content)

	if not succ then
		error("[http] Failed to convert response content to JSON:\n" .. self.content)
	end

	return data
end

return Response