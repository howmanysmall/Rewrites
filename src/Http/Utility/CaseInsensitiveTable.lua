-- CaseInsensitiveTable: access table indices without knowing their case
-- e.g.: headers["content-type"] == headers["Content-Type"]

local t = require(script.Parent.t)

local next = next
local t_table = t.table

return function(Table)
	assert(t_table(Table))

	local Metatable = setmetatable({}, {
		__index = function(self, Index)
			return rawget(self, string.lower(Index))
		end;

		__newindex = function(self, Index, Value)
			rawset(self, string.lower(Index), Value)
		end;
	})

	for Index, Value in next, Table do
		Metatable[Index] = Value
	end

	return Metatable
end