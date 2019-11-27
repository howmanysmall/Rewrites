local HttpService = game:GetService("HttpService")
local Cookie = require(script.Cookie)
local next = next

local CookieJar = {}
CookieJar.__index = CookieJar

function CookieJar.new()
	return setmetatable({
		__cookiejar = true;  -- used to differentiate from dictionaries
		cookies = {};
	}, CookieJar)
end

function CookieJar:Insert(name, value, opts)
	-- set new cookies in cookie jar
	self.cookies[name] = Cookie.new(name, value, opts)
	return self
end

function CookieJar:SetCookie(s)
	-- add cookie from set-cookie string
	local c = Cookie.FromSet(s)
	self.cookies[c.name] = c
end

function CookieJar:Delete(name)
	self.cookies[name] = nil
end

function CookieJar:String()
	-- convert to header string
	local str = ""

	for _, cookie in next, self.cookies do
		if str then
			str = str .. "; "
		end

		str = str .. string.format("%s=%s", cookie.name, cookie.value)
	end

	return str
end

function CookieJar:__tostring()
	return HttpService:JSONEncode(self.domains)
end

return CookieJar