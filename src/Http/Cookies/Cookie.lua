local Utility = require(script.Parent.Parent.Utility)
local StringPlus = Utility.StringPlus
local Url = Utility.Url
local t = Utility.t

local StringPlus_Trim = StringPlus.Trim
local Url_Parse = Url.Parse

local Cookie = {}
Cookie.__index = Cookie

local DEFAULT_OPTIONS = {
	domain = "";
	path = "";
}

function Cookie.new(name, value, opts)
	opts = opts or DEFAULT_OPTIONS

	return setmetatable({
		name = name;
		value = value;
		domain = opts.domain;
		path = opts.path;
	}, Cookie)
end

function Cookie.FromSet(Set)
	warn("SET:", tostring(Set))
	assert(t.string(Set))

	local Options = {}
	local Arguments = string.split(Set, ";")
	local NameValue = string.split(table.remove(Arguments, 1), "=")

	for _, Value in ipairs(Arguments) do
		local KeyValue = string.split(Value, "=")
		Options[string.lower(StringPlus_Trim(KeyValue[1]))] = StringPlus_Trim(KeyValue[2])
	end

	return Cookie.new(StringPlus_Trim(NameValue[1]), StringPlus_Trim(NameValue[2]), Options)
end

--local function FromSet1(s)
--	local opts = {}
--	local args = string.split(s, ";")
--
--	local nv = string.split(args[1], "=")
--	local name, value = StringPlus_Trim(nv[1]), StringPlus_Trim(nv[2])
--
--	for i = 2, #args do
--		local kv = string.split(args[i], "=")
--		local k, v = string.lower(StringPlus_Trim(kv[1])), StringPlus_Trim(kv[2])
--		opts[k] = v
--	end
--
--	return name, value, opts
--end

function Cookie:Matches(url)
	-- check if cookie should be used for URL
	if not self.domain then
		return true
	end

	local u = Url_Parse(url)

	if string.sub(self.domain, 1, 1) == "." then -- wildcard domain
		--if not (string.sub(u.host, -#self.domain, -1) == self.domain or u.host == string.sub(self.domain, 2)) then
		if string.sub(u.host, -#self.domain, -1) ~= self.domain or u.host ~= string.sub(self.domain, 2) then
			return false
		end
	else
		if u.host ~= self.domain then
			return false
		end
	end

	if self.path and not string.sub(u.path, 1, #self.path) == self.path then
		return false
	end

	return true
end

return Cookie