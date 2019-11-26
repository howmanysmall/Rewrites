local SaveData = require(script.Parent.SaveData)
local PlayerDataStore = require(script.Parent.PlayerDataStore)
local t = require(script.Parent.t)

local Types = {
	optionalString = t.optional(t.string),
	userId = t.intersection(t.integer, t.numberPositive),
	arrayOfStrings = t.map(t.integer, t.string),
	setTuple = t.tuple(t.string, t.optional(t.boolean)),

	player = t.instanceOf("Player"),
	dataStoreUnion = t.union(
		t.instanceIsA("GlobalDataStore"),
		t.table
	),
}

function Types.instanceOfClass(class)
	assert(t.table(class))
	return function(value)
		local tableSuccess, tableError = t.table(value)
		if not tableSuccess then
			return false, tableError or ""
		end

		local metatable = getmetatable(value)
		if not metatable or metatable.__index ~= class then
			return false, "bad member of class"
		end

		return true
	end
end

Types.saveData = Types.instanceOfClass(SaveData)
Types.playerDataStore = Types.instanceOfClass(PlayerDataStore)

Types.updateTuple = t.tuple(
	Types.arrayOfStrings,
	t.callback
)

Types.saveDataTuple = t.tuple(
	Types.playerDataStore,
	Types.userId
)

Types.doUpdateTuple = t.tuple(
	Types.saveData,
	Types.arrayOfStrings,
	t.callback
)

Types.updateAsyncTuple = t.tuple(
	Types.dataStoreUnion,
	t.string,
	t.callback
)

Types.getAsyncTuple = t.tuple(
	Types.dataStoreUnion,
	t.string
)

Types.setAsyncTuple = t.tuple(
	Types.dataStoreUnion,
	t.string,
	t.any
)

return Types