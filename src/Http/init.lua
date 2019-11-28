-- HTTP Module by Patrick Dill
-- based on Python Requests (python-requests.org)

-- Original: https://github.com/jpatrickdill/roblox-requests
-- Documentation: https://jpatrickdill.github.io/roblox-requests/

-- Updated the original to use UpperPascalCase by HowManySmall.

-- API --
local Request = require(script.Request)
local Session = require(script.Session)
local Forms = require(script.Form)
local RateLimiter = require(script.RateLimit)

local Utility = require(script.Utility)
local StringPlus = Utility.StringPlus

local StringPlus_TitleCase = StringPlus.TitleCase

local Http = {
	VERSION = "0.2.0";
	Request = Request.new;
	Session = Session.new;
	FormData = Forms.FormData.new;
	File = Forms.File.new;
	Utility = Utility;
}

function Http.Send(Method, Url, Options)
	-- quick method to send http requests
	--  method: (str) HTTP Method
	--	 url: (str) Fully qualified URL
	-- options (dictionary):
		-- headers: (dictionary) Headers to send with request
		--   query: (dictionary) Query string parameters
		--	data: (str OR dictionary) Data to send in POST or PATCH request
		--	 log: (bool) Whether to log the request
		-- cookies: (CookieJar OR dict) Cookies to use in request

	Options = Options or {}
	return Request.new(Method, Url, Options):Send()
end

-- create quick functions for each http method
for _, Method in ipairs{"GET", "POST", "HEAD", "OPTIONS", "PUT", "DELETE", "PATCH"} do
	Http[StringPlus_TitleCase(Method)] = function(Url, Options)
		return Http.Send(Method, Url, Options)
	end
end

function Http.SetRateLimit(Requests, Period)
	-- sets rate limit settings
	local RateLimit = RateLimiter.Get("http", Requests, Period)

	print("[Http] RateLimiter settings changed: ", RateLimit.rate, "reqs /", RateLimit.window_size, "secs")
end

return Http