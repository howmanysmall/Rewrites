-- HTTP Module by Patrick Dill
-- based on Python Requests (python-requests.org)

-- Original: https://github.com/jpatrickdill/roblox-requests
-- Documentation: https://jpatrickdill.github.io/roblox-requests/

-- Updated the original to use UpperPascalCase.

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

function Http.Send(method, url, opts)
	-- quick method to send http requests
	--  method: (str) HTTP Method
	--	 url: (str) Fully qualified URL
	-- options (dictionary):
		-- headers: (dictionary) Headers to send with request
		--   query: (dictionary) Query string parameters
		--	data: (str OR dictionary) Data to send in POST or PATCH request
		--	 log: (bool) Whether to log the request
		-- cookies: (CookieJar OR dict) Cookies to use in request

	opts = opts or {}
	return Request.new(method, url, opts):Send()
end

-- create quick functions for each http method
for _, method in ipairs{"GET", "POST", "HEAD", "OPTIONS", "PUT", "DELETE", "PATCH"} do
	Http[StringPlus_TitleCase(method)] = function(url, opts)
		return Http.Send(method, url, opts)
	end
end

function Http.SetRateLimit(requests, period)
	-- sets rate limit settings
	local rl = RateLimiter.Get("http", requests, period)

	print("[Http] RateLimiter settings changed: ", rl.rate, "reqs /", rl.window_size, "secs")
end

return Http