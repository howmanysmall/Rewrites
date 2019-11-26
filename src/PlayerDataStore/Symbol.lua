local t = require(script.Parent.t)
local Symbol = {}

function Symbol.named(name)
	assert(t.string(name))
	local self = newproxy(true)

	getmetatable(self).__tostring = function()
		return name
	end

	return self
end

return Symbol