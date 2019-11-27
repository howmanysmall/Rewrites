local t = require(script.Parent.t)

local Types = {
	optionalBoolean = t.optional(t.boolean),
	optionalFunction = t.optional(t.callback),
	optionalNumber = t.optional(t.number),

	integerOrString = t.union(t.integer, t.string),

	arrayFunctionTuple = t.tuple(t.table, t.callback),
	instanceStringTuple = t.tuple(t.Instance, t.string),
	mapToRangeTuple = t.tuple(t.number, t.number, t.number, t.number, t.number),
	positiveInteger = t.intersection(t.integer, t.numberPositive),
}

Types.beautifyTuple = t.tuple(t.number, Types.optionalBoolean)
Types.binarySearchTuple = t.tuple(t.table, t.any, Types.optionalFunction)
Types.normalTuple = t.tuple(Types.optionalNumber, Types.OptionalNumber, Types.optionalNumber)
Types.reduceTuple = t.tuple(t.table, t.callback, Types.optionalNumber)
Types.skipTuple = t.tuple(t.table, Types.positiveInteger)

return Types