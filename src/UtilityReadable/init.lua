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

	@param [t:callback] callback The function you want to pass.
	@returns [t:callback] The debounce-able function.
**--]]
function Utility.debounce(callback)
	assert(t.callback(callback))
	local isRunning

	return function(...)
		if not isRunning then
			isRunning = true
			callback(...)
			isRunning = false
		end
	end
end

--[[**
	Gets all the children of the given class inside of the given parent.

	@param [t:Instance] parent The parent you want to search in.
	@param [t:string] className The class you want to get.
	@returns [t:array<t:instanceIsA<className>>] The array of all the found children.
**--]]
function Utility.getChildrenOfClass(parent, className)
	assert(Types.instanceStringTuple(parent, className))
	local children = {}
	local length = 0

	for _, child in ipairs(parent:GetChildren()) do
		if child:IsA(className) then
			length = length + 1
			children[length] = child
		end
	end

	return children
end

--[[**
	Gets all the descendants of the given class inside of the given parent.

	@param [t:Instance] parent The parent you want to search in.
	@param [t:string] className The class you want to get.
	@returns [t:array<t:instanceIsA<className>>] The array of all the found descendants.
**--]]
function Utility.getDescendantsOfClass(parent, className)
	assert(Types.instanceStringTuple(parent, className))
	local descendants = {}
	local length = 0

	for _, descendant in ipairs(parent:GetDescendants()) do
		if descendant:IsA(className) then
			length = length + 1
			descendants[length] = descendant
		end
	end

	return descendants
end

--[[**
	Gets the first ancestor of the given object with the given CollectionService tag.

	@param [t:Instance] object The instance you want to search from.
	@param [t:string] tagName The tag you are searching for.
	@returns [t:Instance] The ancestor found.
**--]]
function Utility.findFirstAncestorWithTag(object, tagName)
	assert(Types.instanceStringTuple(object, tagName))
	local ancestor = object.Parent

	while ancestor do
		if CollectionService:HasTag(ancestor, tagName) then
			return ancestor
		end

		ancestor = ancestor.Parent
	end

	return nil
end

--[[**
	Takes two ranges and a real number, and returns the mapping of the real number from the first to the second range.

	@param [t:number] value The number you want to map.
	@param [t:number] inMin The number to serve as the minimum input.
	@param [t:number] inMax The number to serve as the maximum input.
	@param [t:number] outMin The number to serve as the minimum output.
	@param [t:number] outMax The number to serve as the maximum output.
	@returns [t:number] The mapped number.
**--]]
function Utility.mapToRange(value, inMin, inMax, outMin, outMax)
	assert(Types.mapToRangeTuple(value, inMin, inMax, outMin, outMax))
	return (value - inMin) * (outMax - outMin) / (inMax - inMin) + outMin
end

--[[**
	This allows you to construct a new array by calling the given function on each value in the array.

	@param [t:table] array The array you want to map.
	@param [t:callback] callback The function you are using to map.
	@returns [t:table] The mapped array.
**--]]
function Utility.map(array, callback)
	assert(Types.arraycallbackTuple(array, callback))

	local mappedArray = {}
	for index, value in ipairs(array) do
		mappedArray[index] = callback(value)
	end

	return mappedArray
end

--[[**
	This allows you to create an array based on the given array and a function. If the function returns true, the value remains in the new array; if the function returns false, the value is excluded from the new array.

	@param [t:table] array The array you want to filter.
	@param [t:callback] callback The function you are using to filter.
	@returns [t:table] The filtered array.
**--]]
function Utility.filter(array, callback)
	assert(Types.arraycallbackTuple(array, callback))
	local filteredArray = {}
	local length = 0

	for _, value in ipairs(array) do
		if callback(value) then
			length = length + 1
			filteredArray[length] = value
		end
	end

	return filteredArray
end

--[[**
	This allows you to reduce an array to a single value. Useful for quickly summing up an array.

	@param [t:table] array The array you want to reduce.
	@param [t:callback] callback The function you are using to reduce.
	@param [t:optional<t:number>] initialValue The initial value to use. Defaults to 0.
	@returns [t:number] The reduced value.
**--]]
function Utility.reduce(array, callback, initialValue)
	assert(Types.reduceTuple(array, callback, initialValue))

	local reduceValue = initialValue or 0
	for _, value in ipairs(array) do
		reduceValue = callback(reduceValue, value)
	end

	return reduceValue
end

--[[**
	Takes an array and a function, and returns two arrays, one where all the values satisfied the function, and one where all the values failed.

	@param [t:table] array The array you want to partition.
	@param [t:callback] callback The function you are using to partition.
	@returns [t:tuple<t:table, t:table>] The partitioned arrays.
**--]]
function Utility.partition(array, callback)
	assert(Types.arraycallbackTuple(array, callback))
	local leftArray, rightArray = {}, {}
	local leftLength, rightLength = 0, 0

	for _, value in ipairs(array) do
		if callback(value) then
			leftLength = leftLength + 1
			leftArray[leftLength] = value
		else
			rightLength = rightLength + 1
			rightArray[rightLength] = value
		end
	end

	return leftArray, rightArray
end

--[[**
	Returns every value in the array, removing the first one.

	@param [t:table] array The array you want to use.
	@returns [t:table] The new array.
**--]]
function Utility.rest(array)
	assert(t.table(array))
	local length = #array

	if length < 8000 then
		return{table.unpack(array, 2, length)}
	else
		local newArray = table.create(length - 1)
		for index, value in ipairs(array) do
			if index ~= 1 then
				newArray[index - 1] = value
			end
		end

		return newArray
	end
end

--[[**
	Returns the first element in the array.

	@param [t:table] array The array you want to use.
	@returns [t:any] The first element in the array.
**--]]
function Utility.first(array)
	assert(t.table(array))
	return array[0] ~= nil and array[0] or array[1]
end

--[[**
	Reverses the given array.

	@param [t:table] Array The array you want to reverse.
	@returns [t:table] The newly reversed array.
**--]]
function Utility.reverse(array)
	assert(t.table(array))
	local length = #array
	local newArray = table.create(length)
	local topValue = length + 1

	for index = 1, length do
		newArray[index] = array[topValue - index]
	end

	return newArray
end

--[[**
	Like table.remove, but faster. I think it's O(1) versus O(n), but I'm not sure.

	@param [t:table] Array The array you are removing from.
	@param [t:integer] Index The index you want to remove.
**--]]
function Utility.fastRemove(array, index)
	local length = #array
	array[index] = array[length]
	array[length] = nil
end

--[[**
	Same as fastRemove, but it automatically decrements the length value, if there is one.

	@param [t:table] Array The array you are removing from.
	@param [t:integer] Index The index you want to remove.
	@param [t:integer] Length The length value to decrement.
**--]]
function Utility.fastRemoveLength(array, index, length)
	array[index] = array[length]
	array[length] = nil
	length = length - 1
end

--[[**
	This is closer to table.remove in which it returns the removed value. It's slightly slower than the other fastRemove however.

	@param [t:table] Array The array you are removing from.
	@param [t:integer] Index The index you want to remove.
	@returns [t:any] Whatever was removed at the index.
**--]]
function Utility.fastRemoveReturnValue(array, index)
	local length = #array
	local value = array[index]
	array[index] = array[length]
	array[length] = nil
	return value
end

--[[**
	Searches the array for the specified item, and returns its position.

	@param [t:table] array The array you want to search.
	@param [t:any] element The element you are searching for.
	@returns [t:integer] The element's index, if it exists.
**--]]
function Utility.indexOfArray(array, element)
	assert(t.table(array))
	assert(t.any(element))

	for index, value in ipairs(array) do
		if value == element then
			return index
		end
	end
end

--[[**
	Searches the table for the specified item, and returns its position.

	@param [t:table] table The table you want to search.
	@param [t:any] element The element you are searching for.
	@returns [t:integer] The element's index, if it exists.
**--]]
function Utility.indexOfTable(table, element)
	assert(t.table(table))
	assert(t.any(element))

	for index, value in pairs(table) do
		if value == element then
			return index
		end
	end
end

-- Source: https://devforum.roblox.com/t/sandboxed-table-system-add-custom-methods-to-table/391177/12
--[[**
	Skips skipIndex objects in the given array and returns a new array that contains indexes skipIndex + 1 to the end of the original array.

	@param [t:table] array The array you are working on.
	@param [t:intersection<t:integer, t:numberPositive>] skipIndex The number of indexes you are skipping.
	@returns [t:table] The skipped array.
**--]]
function Utility.skip(array, skipIndex)
	assert(Types.skipTuple(array, skipIndex))
	local length = #array
	return table.move(array, skipIndex + 1, length, 1, table.create(length - skipIndex))
end

--[[**
	Takes takeIndex objects from an array and returns a new array only containing those objects.

	@param [t:table] array The array you are working on.
	@param [t:intersection<t:integer, t:numberPositive>] takeIndex The number of indexes you are taking from the original.
	@returns [t:table] The new array.
**--]]
function Utility.Take(array, takeIndex)
	assert(Types.skipTuple(array, takeIndex))
	return table.move(array, 1, takeIndex, 1, table.create(takeIndex))
end

--[[**
	Beautifies a number. Example: 10,000,000 will become 10M.

	@param [t:number] number The number you want to beautify.
	@param [t:optional<t:boolean>] doNotTruncate Determines if the number is truncated. Defaults to false.
	@returns [t:string] The formatted number.
**--]]
function Utility.beautifyNumber(number, doNotTruncate)
	assert(Types.beautifyTuple(number, doNotTruncate))
	doNotTruncate = doNotTruncate or false

	if number == math.huge then
		return "Infinity"
	end

	local magnitude = math.floor(math.log10(number))
	local magnitudeDiv3 = math.floor(magnitude / 3)
	local suffix = MAGNITUDES[magnitudeDiv3]

	if not suffix then
		return tostring(number)
	end

	local fraction = number / (10 ^ (magnitudeDiv3 * 3))
	local formattedNumber = string.format("%.3f", fraction)

	if not doNotTruncate then
		formattedNumber = string.gsub(formattedNumber, "0+$", "")
		formattedNumber = string.gsub(formattedNumber, "%.+$", "")
	end

	return string.format("%s%s", formattedNumber, suffix)
end

local spawnEvent = Instance.new("BindableEvent")
spawnEvent.Event:Connect(function(callback, arguments)
	callback(arguments())
end)

--[[**
	Spawns the given function on a new thread, but instantly like spawn does and without obscuring errors like coroutines do.

	@param [t:callback] callback The function you want to spawn.
	@param [t:any] ... The optional arguments you want the function to call.
**--]]
function Utility.fastSpawn(callback, ...)
	assert(t.callback(callback))
	local arguments = table.pack(...)

	spawnEvent:Fire(callback, function()
		return table.unpack(arguments, 1, arguments.n)
	end)
end

--[[**
	Formats a number with commas, like so: 1000 => 1,000.
	Source: https://github.com/phyber/Snippets/blob/master/Lua/commify.lua

	@param [t:union<t:integer, t:string>] integer The integer you want to format.
	@returns [t:string] The same number, but formatted!
**--]]
function Utility.commaInteger(integer)
	assert(Types.integerOrString(integer))
	local finalNumber = ""
	local count = 0

	for character in string.gmatch(string.reverse(tostring(integer)), "%d") do
		if count ~= 0 and count % 3 == 0 then
			finalNumber = finalNumber .. "," .. character
		else
			finalNumber = finalNumber .. character
		end

		count = count + 1
	end

	return string.reverse(finalNumber)
end

--[[**
	Generates a random number generator along a Normal distribution curve.

	@param [t:optional<t:number>] average The average number. Defaults to 0.
	@param [t:optional<t:number>] standardDeviation The standard deviation. Defaults to 1.
	@param [t:optional<t:number>] seed The random number generator seed. Defaults to tick() % 1 * 1E7.
	@returns [t:number] A number along the normal curve. Normal curve [-1, 1] * standardDeviation + Average.
**--]]
function Utility.normal(average, standardDeviation, seed)
	assert(Types.normalTuple(average, standardDeviation, seed))
	local randomLib = Random.new(seed or tick() % 1 * 1E7)

	return (average or 0) +
		math.sqrt(-2 * math.log(randomLib:NextNumber())) *
		math.cos(6.2831853071796 * randomLib:NextNumber()) *
		0.5 * (standardDeviation or 1)
end

--[[**
	Searches a sorted array for the given value. This is much faster than table.find, but is only for sorted arrays.

	@param [t:table] array The array you are searching through.
	@param [t:any] value The value you want to find.
	@param [t:optional<t:callback>] callback The optional function to search using. Defaults to Left < Right.
	@returns [t:integer] The index of the found value. Will be -1 if it wasn't found.
**--]]
function Utility.binarySearch(array, value, callback)
	assert(Types.binarySearchTuple(array, value, callback))
	if callback then
		local low, high, floorValue, middle
		low = 1
		high = #array

		while low <= high do
			floorValue = (high - low) / 2
			floorValue = floorValue - floorValue % 1
			middle = low + floorValue

			if callback(value, array[middle]) then
				high = middle - 1
			elseif callback(array[middle], value) then
				low = middle + 1
			else
				while middle >= 1 and not (callback(array[middle], value) or callback(value, array[middle])) do
					middle = middle - 1
				end

				return middle + 1
			end
		end

		return -1
	else
		local low, high, floorValue, middle
		low = 1
		high = #array

		while low <= high do
			floorValue = (high - low) / 2
			floorValue = floorValue - floorValue % 1
			middle = low + floorValue

			if value < array[middle] then
				high = middle - 1
			elseif array[middle] < value then
				low = middle + 1
			else
				while middle >= 1 and not ((array[middle] < value) or (value < array[middle])) do
					middle = middle - 1
				end

				return middle + 1
			end
		end

		return -1
	end
end

--[[**
	Creates a Symbol with the given name. When printed or coerced to a string, the symbol will turn into the string given as its name.

	@param [t:string] symbolName The name of the Symbol.
	@returns [t:userdata] The userdata that represents the Symbol.
**--]]
function Utility.createSymbol(symbolName)
	assert(t.string(symbolName))
	local self = newproxy(true)

	getmetatable(self).__tostring = function()
		return "Symbol(" .. symbolName .. ")"
	end

	return self
end

return Utility