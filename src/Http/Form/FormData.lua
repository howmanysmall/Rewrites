local HttpService = game:GetService("HttpService")
local Utility = require(script.Parent.Parent.Utility)
local Base64 = Utility.Base64
local StringPlus = Utility.StringPlus

local next = next
local ipairs = ipairs
local Base64_Encode = Base64.Encode
local StringPlus_RandomString = StringPlus.RandomString

local FormData = {}
FormData.__index = FormData

function FormData.new(fields)
	fields = fields or {}
	local self = setmetatable({
		__FormData = true;
		boundary = "--FormBoundary-" .. StringPlus_RandomString(28);
		content_type = "application/x-www-form-urlencoded";
		fields = {};
	}, FormData)

	for k, v in next, fields do
		self:AddField(k, v)
	end

	return self
end

function FormData:AddField(name, value)
	-- set content-type to multipart if file is provided
	if value.__IsFile then
		self.content_type = "multipart/form-data; boundary=\"" .. self.boundary .. "\""
	end

	self.fields[#self.fields + 1] = {
		Name = name;
		Value = value;
	}
end

function FormData:Build()
	-- return request payload data for these form values
	local content = ""

	if self.content_type == "application/x-www-form-urlencoded" then
		for _, field in ipairs(self.fields) do
			if field.Value.__IsFile then
				error("[http] URL encoded forms cannot contain any files")
			end

			if string.find(field.Name, "=") or string.find(field.Name, "&") then
				error("[http] Form field names must not contain \"=\" or \"&\"")
			end

			-- handle lists
			if type(field.Value) == "table" then
				for _, val in ipairs(field.Value) do
					if #content > 0 then
						content = content .. "&"
					end

					content = content .. field.Name .. "=" .. HttpService:UrlEncode(val)
				end
			else
				if #content > 0 then
					content = content .. "&"
				end

				content = content .. field.Name .. "=" .. HttpService:UrlEncode(field.Value)
			end
		end
	else
		for _, field in next, self.fields do
			content = content .. "--" .. self.boundary .. "\r\n"

			local val = field.Value
			content = content .. string.format("Content-Disposition: form-data; name=%q", field.Name)

			-- handle files
			if field.Value.__IsFile then
				val = field.Value.content

				content = content .. string.format("; filename=%q", field.Value.name)
				content = content .. "\r\nContent-Type: " .. field.Value.content_type

				-- encode non-text files
				if string.sub(field.Value.content_type, 1, 5) ~= "text/" then
					val = Base64_Encode(val)
					content = content .. "\r\nContent-Transfer-Encoding: base64"
				end
			end

			content = content .. "\r\n\r\n\r\n" .. val .. "\r\n"
		end

		content = content .. "--" .. self.boundary .. "--"
	end

	return content
end

return FormData