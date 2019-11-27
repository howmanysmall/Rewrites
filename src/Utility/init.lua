local CollectionService = game:GetService("CollectionService")
local t = require(script.t)
local Types = require(script.Types)

local Utility = {
	BindableEvent = require(script.BindableEvent);
	Timer = require(script.Timer);
	Types = Types;
	t = t;
}

local MAGNITUDES = {
	[2] = "M";
	[3] = "B";
	[4] = "T";
	[5] = "Qd";
	[6] = "Qt";
	[7] = "Sx";
	[8] = "Sp";
	[9] = "Ot";
	[10] = "Nn";
	[11] = "De";
	[12] = "Ud";
	[13] = "Dd";
	[14] = "Td";
	[15] = "QdD";
	[16] = "QtD";
	[17] = "SxD";
	[18] = "SpD";
	[19] = "OtD";
	[20] = "NnD";
	[21] = "Vi";
}

--[[**
	Debounces a function. You can also pass arguments within the function.

	@param [t:callback] Function The function you want to pass.
	@returns [t:callback] The debounce-able function.
**--]]
function Utility.Debounce(Function)
	assert(t.callback(Function))
	local IsRunning

	return function(...)
		if not IsRunning then
			IsRunning = true
			Function(...)
			IsRunning = false
		end
	end
end

--[[**
	Gets all the children of the given class inside of the given parent.

	@param [t:Instance] Parent The parent you want to search in.
	@param [t:string] ClassName The class you want to get.
	@returns [t:array<t:instanceIsA<ClassName>>] The array of all the found children.
**--]]
function Utility.GetChildrenOfClass(Parent, ClassName)
	assert(Types.InstanceStringTuple(Parent, ClassName))
	local Children = {}
	local Length = 0

	for _, Child in ipairs(Parent:GetChildren()) do
		if Child:IsA(ClassName) then
			Length = Length + 1
			Children[Length] = Child
		end
	end

	return Children
end

--[[**
	Gets all the descendants of the given class inside of the given parent.

	@param [t:Instance] Parent The parent you want to search in.
	@param [t:string] ClassName The class you want to get.
	@returns [t:array<t:instanceIsA<ClassName>>] The array of all the found descendants.
**--]]
function Utility.GetDescendantsOfClass(Parent, ClassName)
	assert(Types.InstanceStringTuple(Parent, ClassName))
	local Descendants = {}
	local Length = 0

	for _, Descendant in ipairs(Parent:GetDescendants()) do
		if Descendant:IsA(ClassName) then
			Length = Length + 1
			Descendants[Length] = Descendant
		end
	end

	return Descendants
end

--[[**
	Gets the first ancestor of the given object with the given CollectionService tag.

	@param [t:Instance] Object The instance you want to search from.
	@param [t:string] TagName The tag you are searching for.
	@returns [t:Instance] The ancestor found.
**--]]
function Utility.FindFirstAncestorWithTag(Object, TagName)
	assert(Types.InstanceStringTuple(Object, TagName))
	local Ancestor = Object.Parent

	while Ancestor do
		if CollectionService:HasTag(Ancestor, TagName) then
			return Ancestor
		end

		Ancestor = Ancestor.Parent
	end

	return nil
end

--[[**
	Takes two ranges and a real number, and returns the mapping of the real number from the first to the second range.

	@param [t:number] Value The number you want to map.
	@param [t:number] InMin The number to serve as the minimum input.
	@param [t:number] InMax The number to serve as the maximum input.
	@param [t:number] OutMin The number to serve as the minimum output.
	@param [t:number] OutMax The number to serve as the maximum output.
	@returns [t:number] The mapped number.
**--]]
function Utility.MapToRange(Value, InMin, InMax, OutMin, OutMax)
	assert(Types.MapToRangeTuple(Value, InMin, InMax, OutMin, OutMax))
	return (Value - InMin) * (OutMax - OutMin) / (InMax - InMin) + OutMin
end

--[[**
	This allows you to construct a new array by calling the given function on each value in the array.

	@param [t:table] Array The array you want to map.
	@param [t:callback] Function The function you are using to map.
	@returns [t:table] The mapped array.
**--]]
function Utility.Map(Array, Function)
	assert(Types.ArrayFunctionTuple(Array, Function))

	local MappedArray = {}
	for Index, Value in ipairs(Array) do
		MappedArray[Index] = Function(Value)
	end

	return MappedArray
end

--[[**
	This allows you to create an array based on the given array and a function. If the function returns true, the value remains in the new array; if the function returns false, the value is excluded from the new array.

	@param [t:table] Array The array you want to filter.
	@param [t:callback] Function The function you are using to filter.
	@returns [t:table] The filtered array.
**--]]
function Utility.Filter(Array, Function)
	assert(Types.ArrayFunctionTuple(Array, Function))
	local FilteredArray = {}
	local Length = 0

	for _, Value in ipairs(Array) do
		if Function(Value) then
			Length = Length + 1
			FilteredArray[Length] = Value
		end
	end

	return FilteredArray
end

--[[**
	This allows you to reduce an array to a single value. Useful for quickly summing up an array.

	@param [t:table] Array The array you want to reduce.
	@param [t:callback] Function The function you are using to reduce.
	@param [t:optional<t:number>] InitialValue The initial value to use. Defaults to 0.
	@returns [t:number] The reduced value.
**--]]
function Utility.Reduce(Array, Function, InitialValue)
	assert(Types.ReduceTuple(Array, Function, InitialValue))

	local ReduceValue = InitialValue or 0
	for _, Value in ipairs(Array) do
		ReduceValue = Function(ReduceValue, Value)
	end

	return ReduceValue
end

--[[**
	Takes an array and a function, and returns two arrays, one where all the values satisfied the function, and one where all the values failed.

	@param [t:table] Array The array you want to partition.
	@param [t:callback] Function The function you are using to partition.
	@returns [t:tuple<t:table, t:table>] The partitioned arrays.
**--]]
function Utility.Partition(Array, Function)
	assert(Types.ArrayFunctionTuple(Array, Function))
	local LeftArray, RightArray = {}, {}
	local LeftLength, RightLength = 0, 0

	for _, Value in ipairs(Array) do
		if Function(Value) then
			LeftLength = LeftLength + 1
			LeftArray[LeftLength] = Value
		else
			RightLength = RightLength + 1
			RightArray[RightLength] = Value
		end
	end

	return LeftArray, RightArray
end

--[[**
	Returns every value in the array, removing the first one.

	@param [t:table] Array The array you want to use.
	@returns [t:table] The new array.
**--]]
function Utility.Rest(Array)
	assert(t.table(Array))
	local Length = #Array

	if Length < 8000 then
		return{table.unpack(Array, 2, Length)}
	else
		local NewArray = table.create(Length - 1)
		for Index, Value in ipairs(Array) do
			if Index ~= 1 then
				NewArray[Index - 1] = Value
			end
		end

		return NewArray
	end
end

--[[**
	Returns the first element in the array.

	@param [t:table] Array The array you want to use.
	@returns [t:any] The first element in the array.
**--]]
function Utility.First(Array)
	assert(t.table(Array))
	return Array[0] ~= nil and Array[0] or Array[1]
end

--[[**
	Reverses the given array.

	@param [t:table] Array The array you want to reverse.
	@returns [t:table] The newly reversed array.
**--]]
function Utility.Reverse(Array)
	assert(t.table(Array))
	local Length = #Array
	local NewArray = table.create(Length)
	local TopValue = Length + 1

	for Index = 1, Length do
		NewArray[Index] = Array[TopValue - Index]
	end

	return NewArray
end

--[[**
	Like table.remove, but faster. I think it's O(1) versus O(n), but I'm not sure.

	@param [t:table] Array The array you are removing from.
	@param [t:integer] Index The index you want to remove.
**--]]
function Utility.FastRemove(Array, Index)
	local Length = #Array
	Array[Index] = Array[Length]
	Array[Length] = nil
end

--[[**
	Same as FastRemove, but it automatically decrements the length value, if there is one.

	@param [t:table] Array The array you are removing from.
	@param [t:integer] Index The index you want to remove.
	@param [t:integer] Length The length value to decrement.
**--]]
function Utility.FastRemoveLength(Array, Index, Length)
	Array[Index] = Array[Length]
	Array[Length] = nil
	Length = Length - 1
end

--[[**
	This is closer to table.remove in which it returns the removed value. It's slightly slower than the other FastRemove however.

	@param [t:table] Array The array you are removing from.
	@param [t:integer] Index The index you want to remove.
	@returns [t:any] Whatever was removed at the index.
**--]]
function Utility.FastRemoveReturnValue(Array, Index)
	local Length = #Array
	local Value = Array[Index]
	Array[Index] = Array[Length]
	Array[Length] = nil
	return Value
end

--[[**
	Searches the array for the specified item, and returns its position.

	@param [t:table] Array The array you want to search.
	@param [t:any] Element The element you are searching for.
	@returns [t:integer] The element's index, if it exists.
**--]]
function Utility.IndexOfArray(Array, Element)
	assert(t.table(Array))
	assert(t.any(Element))

	for Index, Value in ipairs(Array) do
		if Value == Element then
			return Index
		end
	end
end

--[[**
	Searches the table for the specified item, and returns its position.

	@param [t:table] Table The table you want to search.
	@param [t:any] Element The element you are searching for.
	@returns [t:integer] The element's index, if it exists.
**--]]
function Utility.IndexOfTable(Table, Element)
	assert(t.table(Table))
	assert(t.any(Element))

	for Index, Value in next, Table do
		if Value == Element then
			return Index
		end
	end
end

-- Source: https://devforum.roblox.com/t/sandboxed-table-system-add-custom-methods-to-table/391177/12
--[[**
	Skips SkipIndex objects in the given array and returns a new array that contains indexes SkipIndex + 1 to the end of the original array.

	@param [t:table] Array The array you are working on.
	@param [t:intersection<t:integer, t:numberPositive>] SkipIndex The number of indexes you are skipping.
	@returns [t:table] The skipped array.
**--]]
function Utility.Skip(Array, SkipIndex)
	assert(Types.SkipTuple(Array, SkipIndex))
	local Length = #Array
	return table.move(Array, SkipIndex + 1, Length, 1, table.create(Length - SkipIndex))
end

--[[**
	Takes TakeIndex objects from an array and returns a new array only containing those objects.

	@param [t:table] Array The array you are working on.
	@param [t:intersection<t:integer, t:numberPositive>] TakeIndex The number of indexes you are taking from the original.
	@returns [t:table] The new array.
**--]]
function Utility.Take(Array, TakeIndex)
	assert(Types.SkipTuple(Array, TakeIndex))
	return table.move(Array, 1, TakeIndex, 1, table.create(TakeIndex))
end

--[[**
	Beautifies a number. Example: 10,000,000 will become 10M.

	@param [t:number] Number The number you want to beautify.
	@param [t:optional<t:boolean>] DoNotTruncate Determines if the number is truncated. Defaults to false.
	@returns [t:string] The formatted number.
**--]]
function Utility.BeautifyNumber(Number, DoNotTruncate)
	assert(Types.BeautifyTuple(Number, DoNotTruncate))
	DoNotTruncate = DoNotTruncate or false

	if Number == math.huge then
		return "Infinity"
	end

	local Magnitude = math.floor(math.log10(Number))
	local MagnitudeDiv3 = math.floor(Magnitude / 3)
	local Suffix = MAGNITUDES[MagnitudeDiv3]

	if not Suffix then
		return tostring(Number)
	end

	local Fraction = Number / (10 ^ (MagnitudeDiv3 * 3))
	local FormattedNumber = string.format("%.3f", Fraction)

	if not DoNotTruncate then
		FormattedNumber = string.gsub(FormattedNumber, "0+$", "")
		FormattedNumber = string.gsub(FormattedNumber, "%.+$", "")
	end

	return string.format("%s%s", FormattedNumber, Suffix)
end

local SpawnEvent = Instance.new("BindableEvent")
SpawnEvent.Event:Connect(function(Function, Arguments)
	Function(Arguments())
end)

--[[**
	Spawns the given function on a new thread, but instantly like spawn does and without obscuring errors like coroutines do.

	@param [t:callback] Function The function you want to spawn.
	@param [t:any] ... The optional arguments you want the function to call.
**--]]
function Utility.FastSpawn(Function, ...)
	assert(t.callback(Function))
	local Arguments = table.pack(...)

	SpawnEvent:Fire(Function, function()
		return table.unpack(Arguments, 1, Arguments.n)
	end)
end

--[[**
	Formats a number with commas, like so: 1000 => 1,000.
	Source: https://github.com/phyber/Snippets/blob/master/Lua/commify.lua

	@param [t:union<t:integer, t:string>] Integer The integer you want to format.
	@returns [t:string] The same number, but formatted!
**--]]
function Utility.CommaInteger(Integer)
	assert(Types.IntegerOrString(Integer))
	local FinalNumber = ""
	local Count = 0

	for Character in string.gmatch(string.reverse(tostring(Integer)), "%d") do
		if Count ~= 0 and Count % 3 == 0 then
			FinalNumber = FinalNumber .. "," .. Character
		else
			FinalNumber = FinalNumber .. Character
		end

		Count = Count + 1
	end

	return string.reverse(FinalNumber)
end

--[[**
	Generates a random number generator along a Normal distribution curve.

	@param [t:optional<t:number>] Average The average number. Defaults to 0.
	@param [t:optional<t:number>] StandardDeviation The standard deviation. Defaults to 1.
	@param [t:optional<t:number>] Seed The random number generator seed. Defaults to tick() % 1 * 1E7.
	@returns [t:number] A number along the normal curve. Normal curve [-1, 1] * StandardDeviation + Average.
**--]]
function Utility.Normal(Average, StandardDeviation, Seed)
	assert(Types.NormalTuple(Average, StandardDeviation, Seed))
	local RandomLib = Random.new(Seed or tick() % 1 * 1E7)

	return (Average or 0) +
		math.sqrt(-2 * math.log(RandomLib:NextNumber())) *
		math.cos(6.2831853071796 * RandomLib:NextNumber()) *
		0.5 * (StandardDeviation or 1)
end

--[[**
	Searches a sorted array for the given value. This is much faster than table.find, but is only for sorted arrays.

	@param [t:table] Array The array you are searching through.
	@param [t:any] Value The value you want to find.
	@param [t:optional<t:callback>] Function The optional function to search using. Defaults to Left < Right.
	@returns [t:integer] The index of the found value. Will be -1 if it wasn't found.
**--]]
function Utility.BinarySearch(Array, Value, Function)
	assert(Types.BinarySearchTuple(Array, Value, Function))
	if Function then
		local Low, High, FloorValue, Middle
		Low = 1
		High = #Array

		while Low <= High do
			FloorValue = (High - Low) / 2
			FloorValue = FloorValue - FloorValue % 1
			Middle = Low + FloorValue

			if Function(Value, Array[Middle]) then
				High = Middle - 1
			elseif Function(Array[Middle], Value) then
				Low = Middle + 1
			else
				while Middle >= 1 and not (Function(Array[Middle], Value) or Function(Value, Array[Middle])) do
					Middle = Middle - 1
				end

				return Middle + 1
			end
		end

		return -1
	else
		local Low, High, FloorValue, Middle
		Low = 1
		High = #Array

		while Low <= High do
			FloorValue = (High - Low) / 2
			FloorValue = FloorValue - FloorValue % 1
			Middle = Low + FloorValue

			if Value < Array[Middle] then
				High = Middle - 1
			elseif Array[Middle] < Value then
				Low = Middle + 1
			else
				while Middle >= 1 and not ((Array[Middle] < Value) or (Value < Array[Middle])) do
					Middle = Middle - 1
				end

				return Middle + 1
			end
		end

		return -1
	end
end

--[[**
	Creates a Symbol with the given name. When printed or coerced to a string, the symbol will turn into the string given as its name.

	@param [t:string] SymbolName The name of the Symbol.
	@returns [t:userdata] The userdata that represents the Symbol.
**--]]
function Utility.CreateSymbol(SymbolName)
	assert(t.string(SymbolName))
	local self = newproxy(true)

	getmetatable(self).__tostring = function()
		return "Symbol(" .. SymbolName .. ")"
	end

	return self
end

return Utility