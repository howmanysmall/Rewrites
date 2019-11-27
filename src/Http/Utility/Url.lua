-- neturl.lua - a robust url parser and builder
--
-- Bertrand Mansion, 2011-2013; License MIT
-- @module neturl
-- @alias	M

-- https://github.com/golgote/neturl

local M = {
	version = "0.9.0";
	options = {separator = "&"};
	services = {
		acap = 674,
		cap = 1026,
		dict = 2628,
		ftp = 21,
		gopher = 70,
		http = 80,
		https = 443,
		iax = 4569,
		icap = 1344,
		imap = 143,
		ipp = 631,
		ldap = 389,
		mtqp = 1038,
		mupdate = 3905,
		news = 2009,
		nfs = 2049,
		nntp = 119,
		rtsp = 554,
		sip = 5060,
		snmp = 161,
		telnet = 23,
		tftp = 69,
		vemmi = 575,
		afs = 1483,
		jms = 5673,
		rsync = 873,
		prospero = 191,
		videotex = 516
	};
}

local LEGAL_CHARACTERS = {
	["-"] = true, ["_"] = true, ["."] = true, ["!"] = true;
	["~"] = true, ["*"] = true, ["'"] = true, ["("] = true;
	[")"] = true, [":"] = true, ["@"] = true, ["&"] = true;
	["="] = true, ["+"] = true, ["$"] = true, [","] = true;
	[";"] = true; -- can be used for parameters in path
}

local next = next
local ipairs = ipairs

local function Decode(String, Path)
	if not Path then
		String = string.gsub(String, "+", " ")
	end

	return (string.gsub(String, "%%(%x%x)", function(Character)
		return string.char(tonumber(Character, 16))
	end))
end

local function Encode(String)
	return (string.gsub(String, "([^A-Za-z0-9%_%.%-%~])", function(Value)
		return string.upper(string.format("%%%02x", string.byte(Value)))
	end))
end

-- for query values, prefer + instead of %20 for spaces
local function EncodeValue(String)
	return string.gsub(Encode(String), "%%20", "+")
end

local function LegalEncode(Character)
	return LEGAL_CHARACTERS[Character] and Character or Encode(Character)
end

local function EncodeSegment(String)
	return string.gsub(String, "([^a-zA-Z0-9])", LegalEncode)
end

local function Concat(s, u)
	return s .. u:Build()
end

--- builds the url
-- @return a string representing the built url
function M:Build()
	local url = ""
	if self.path then
		local path = self.path
		string.gsub(path, "([^/]+)", EncodeSegment)
		url = url .. tostring(path)
	end

	if self.query then
		local qstring = tostring(self.query)
		if qstring ~= "" then
			url = url .. "?" .. qstring
		end
	end

	if self.host then
		local authority = self.host
		if self.port and self.scheme and M.services[self.scheme] ~= self.port then
			authority = authority .. ":" .. self.port
		end

		local userinfo
		if self.user and self.user ~= "" then
			userinfo = self.user
			if self.password then
				userinfo = userinfo .. ":" .. self.password
			end
		end

		if userinfo and userinfo ~= "" then
			authority = userinfo .. "@" .. authority
		end

		if authority then
			if url ~= "" then
				url = "//" .. authority .. "/" .. string.gsub(url, "^/+", "")
			else
				url = "//" .. authority
			end
		end
	end

	if self.scheme then
		url = self.scheme .. ":" .. url
	end

	if self.fragment then
		url = url .. "#" .. self.fragment
	end

	return url
end

--- builds the querystring
-- @param tab The key/value parameters
-- @param sep The separator to use (optional)
-- @param key The parent key if the value is multi-dimensional (optional)
-- @return a string representing the built querystring
function M.BuildQuery(tab, sep, key)
	local query = {}
	local length = 0
	sep = sep or M.options.separator or "&"

	local keys = {}
	local keysLength = 0
	for k in next, tab do
		keysLength = keysLength + 1
		keys[keysLength] = k
	end

	table.sort(keys)

	for _, name in ipairs(keys) do
		local value = tab[name]
		name = Encode(tostring(name))
		if key then
			name = string.format("%s[%s]", tostring(key), tostring(name))
		end

		if type(value) == "table" then
			length = length + 1
			query[length] = M.BuildQuery(value, sep, name)
		else
			local newValue = EncodeValue(tostring(value))
			if newValue ~= "" then
				length = length + 1
				query[length] = string.format("%s=%s", name, newValue)
			else
				length = length + 1
				query[length] = name
			end
		end
	end

	return table.concat(query, sep)
end

--- Parses the querystring to a table
-- This function can parse multidimensional pairs and is mostly compatible
-- with PHP usage of brackets in key names like ?param[key]=value
-- @param str The querystring to parse
-- @param sep The separator between key/value pairs, defaults to `&`
-- @todo limit the max number of parameters with M.options.max_parameters
-- @return a table representing the query key/value pairs
function M.ParseQuery(str, sep)
	sep = sep or M.options.separator or "&"

	local values = {}
	for key, val in string.gmatch(str, string.format("([^%q=]+)(=*[^%q=]*)", sep, sep)) do
		key = Decode(key)
		local keys = {}
		local keysLength = 0

		key = string.gsub(key, "%[([^%]]*)%]", function(v)
			-- extract keys between balanced brackets
			if string.find(v, "^-?%d+$") then
				v = tonumber(v)
			else
				v = Decode(v)
			end

			keysLength = keysLength + 1
			keys[keysLength] = v
			return "="
		end)

		key = string.gsub(key, "=+.*$", "")
		key = string.gsub(key, "%s", "_") -- remove spaces in parameter name
		val = string.gsub(val, "^=+", "")

		values[key] = values[key] or {}

		local valuesKeyType = type(values[key])
		if keysLength > 0 and valuesKeyType ~= "table" then
			values[key] = {}
		elseif keysLength == 0 and valuesKeyType == "table" then
			values[key] = Decode(val)
		end

		local t = values[key]
		for i, k in ipairs(keys) do
			if type(t) ~= "table" then
				t = {}
			end

			if k == "" then
				k = #t + 1
			end

			t[k] = t[k] or {}
			if i == keysLength then
				t[k] = Decode(val)
			end

			t = t[k]
		end
	end

	return setmetatable(values, {
		__tostring = M.buildQuery;
	})
end

--- set the url query
-- @param query Can be a string to parse or a table of key/value pairs
-- @return a table representing the query key/value pairs
function M:SetQuery(query)
	if type(query) == "table" then
		query = M.BuildQuery(query)
	end

	self.query = M.ParseQuery(query)
	return query
end

--- set the authority part of the url
-- The authority is parsed to find the user, password, port and host if available.
-- @param authority The string representing the authority
-- @return a string with what remains after the authority was parsed
function M:SetAuthority(authority)
	self.authority = authority
	self.port = nil
	self.host = nil
	self.userinfo = nil
	self.user = nil
	self.password = nil

	authority = string.gsub(authority, "^([^@]*)@", function(v)
		self.userinfo = v
		return ""
	end)

	authority = string.gsub(authority, "^%[[^%]]+%]", function(v)
		self.host = v
		return ""
	end)

	authority = string.gsub(authority, ":([^:]*)$", function(v)
		self.port = tonumber(v)
		return ""
	end)

	if authority ~= "" and not self.host then
		self.host = string.lower(authority)
	end

	if self.userinfo then
		local userinfo = self.userinfo
		userinfo = string.gsub(userinfo, ":([^:]*)$", function(v)
			self.password = v
			return ""
		end)

		self.user = userinfo
	end

	return authority
end

--- Parse the url into the designated parts.
-- Depending on the url, the following parts can be available:
-- scheme, userinfo, user, password, authority, host, port, path,
-- query, fragment
-- @param url Url string
-- @return a table with the different parts and a few other functions
function M.Parse(url)
	local comp = {}
	M.SetAuthority(comp, "")
	M.SetQuery(comp, "")

	url = tostring(url or "")
	url = string.gsub(url, "#(.*)$", function(v)
		comp.fragment = v
		return ""
	end)

	url = string.gsub(url, "^([%w][%w%+%-%.]*)%:", function(v)
		comp.scheme = string.lower(v)
		return ""
	end)

	url = string.gsub(url, "%?(.*)", function(v)
		M.SetQuery(comp, v)
		return ""
	end)

	url = string.gsub(url, "^//([^/]*)", function(v)
		M.SetAuthority(comp, v)
		return ""
	end)

	comp.path = Decode(url, true)

	setmetatable(comp, {
		__index = M;
		__concat = Concat;
		__tostring = M.build;
	})

	return comp
end

--- removes dots and slashes in urls when possible
-- This function will also remove multiple slashes
-- @param path The string representing the path to clean
-- @return a string of the path without unnecessary dots and segments
function M.RemoveDotSegments(path)
	if #path == 0 then
		return ""
	end

	local fields = {}
	local startslash = string.sub(path, 1, 1) == "/"
	local endslash = false

	if (#path > 1 or not startslash) and string.sub(path, -1) == "/" then
		endslash = true
	end

	string.gsub(path, "[^/]+", function(c)
		fields[#fields + 1] = c
	end)

	local new = {}
	local j = 0

	for _, c in ipairs(fields) do
		if c == ".." then
			if j > 0 then
				j = j - 1
			end
		elseif c ~= "." then
			j = j + 1
			new[j] = c
		end
	end

	local ret
	if #new > 0 and j > 0 then
		ret = table.concat(new, "/", 1, j)
	else
		ret = ""
	end

	if startslash then
		ret = string.format("/%s", ret)
	end

	if endslash then
		ret = string.format("%s/", ret)
	end

	return ret
end

local function absolutePath(base_path, relative_path)
	if string.sub(relative_path, 1, 1) == "/" then
		return "/" .. string.gsub(relative_path, "^[%./]+", "")
	end

	local path = base_path
	if relative_path ~= "" then
		path = "/" .. string.gsub(path, "[^/]*$", "")
	end

	path = path .. relative_path

	path = string.gsub(path, "([^/]*%./)", function(s)
		if s ~= "./" then
			return s
		else
			return ""
		end
	end)

	path = string.gsub(path, "/%.$", "/")
	local reduced
	while reduced ~= path do
		reduced = path
		path = string.gsub(reduced, "([^/]*/%.%./)", function(s)
			if s ~= "../../" then
				return ""
			else
				return s
			end
		end)
	end

	path = string.gsub(path, "([^/]*/%.%.?)$", function(s)
		if s ~= "../.." then
			return ""
		else
			return s
		end
	end)

	local newReduced
	while newReduced ~= path do
		newReduced = path
		path = string.gsub(newReduced, "^/?%.%./", "")
	end

	return "/" .. path
end

--- builds a new url by using the one given as parameter and resolving paths
-- @param other A string or a table representing a url
-- @return a new url table
function M:Resolve(other)
	if type(self) == "string" then
		self = M.Parse(self)
	end

	if type(other) == "string" then
		other = M.Parse(other)
	end

	if other.scheme then
		return other
	else
		other.scheme = self.scheme
		if not other.authority or other.authority == "" then
			other:SetAuthority(self.authority)
			if not other.path or other.path == "" then
				other.path = self.path
				local query = other.query
				if not query or not next(query) then
					other.query = self.query
				end
			else
				other.path = absolutePath(self.path, other.path)
			end
		end

		return other
	end
end

--- normalize a url path following some common normalization rules
-- described on <a href="http://en.wikipedia.org/wiki/URL_normalization">The URL normalization page of Wikipedia</a>
-- @return the normalized path
function M:Normalize()
	if type(self) == "string" then
		self = M.Parse(self)
	end

	if self.path then
		local path = self.path
		path = absolutePath(path, "")
		-- normalize multiple slashes
		path = string.gsub(path, "//+", "/")
		self.path = path
	end

	return self
end

return M