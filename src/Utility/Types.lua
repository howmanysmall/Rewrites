local t = require(script.Parent.t)

local Types = {
	OptionalBoolean = t.optional(t.boolean);
	OptionalFunction = t.optional(t.callback);
	OptionalNumber = t.optional(t.number);

	IntegerOrString = t.union(t.integer, t.string);

	ArrayFunctionTuple = t.tuple(t.table, t.callback);
	InstanceStringTuple = t.tuple(t.Instance, t.string);
	MapToRangeTuple = t.tuple(t.number, t.number, t.number, t.number, t.number);
	PositiveInteger = t.intersection(t.integer, t.numberPositive);
}

Types.BeautifyTuple = t.tuple(t.number, Types.OptionalBoolean)
Types.BinarySearchTuple = t.tuple(t.table, t.any, Types.OptionalFunction)
Types.NormalTuple = t.tuple(Types.OptionalNumber, Types.OptionalNumber, Types.OptionalNumber)
Types.ReduceTuple = t.tuple(t.table, t.callback, Types.OptionalNumber)
Types.SkipTuple = t.tuple(t.table, Types.PositiveInteger)

return Types