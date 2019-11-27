local Utility = require(script.Parent.Parent.Utility)
local MIME_TYPES = Utility.MimeTypes

local File = {}
File.__index = File

function File.new(...)
	-- File.new(content)
	-- File.new(name, content)
	-- File.new(name, content, content_type)
	local self = setmetatable({
		__IsFile = true;
		name = "unknown";
		content = "";
		content_type = nil;
	}, File)

	local args = table.pack(...)

	if args.n == 1 then
		-- File(content)
		self.content = args[1]
	elseif args.n >= 2 then
		-- File(name, content[, content_type])
		self.name = args[1]
		self.content = args[2]
		self.content_type = args[3]
	end

	-- no content-type provided: guess
	if not self.content_type then
		local ext = string.split(self.name, ".")
		ext = ext[#ext]
		self.content_type = MIME_TYPES[string.lower(ext)] or "text/plain"
	end

	if type(self.content) ~= "string" then
		error(string.format("[http] Invalid file content for file %s", self.name))
	end

	return self
end

function File:__tostring()
	return string.format("File(%q, %q)", self.name, self.content_type)
end

return File