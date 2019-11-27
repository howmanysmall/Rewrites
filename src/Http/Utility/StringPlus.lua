local t = require(script.Parent.t)
local StringPlus = {}

local RandomLib = Random.new(tick() % 1 * 1E7)

local PositiveInteger = t.intersection(t.integer, t.numberPositive)
local OptionalPositiveInteger = t.optional(PositiveInteger)
local OptionalBoolean = t.optional(t.boolean)
local NumberOrString = t.union(t.string, t.number)
local CountTuple = t.tuple(t.string, t.string)
local StartEndWithTuple = t.tuple(t.string, t.string, OptionalBoolean)

local CHARACTERS = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"

--[[**
	Generates a random string between the character bytes 97 and 122.
	@param [t:optional<t:intersection<t:integer, t:numberPositive>>] Length The length of the random string. Defaults to 8.
	@returns [t:string] The random string.
**--]]
function StringPlus.RandomString(Length)
	assert(OptionalPositiveInteger(Length))
	local String = ""

	for _ = 1, Length or 8 do
		String = String .. string.char(RandomLib:NextInteger(97, 122))
	end

	return String
end

--[[**
	Generates a random string between using the constant CHARACTERS string in the module.
	@param [t:optional<t:intersection<t:integer, t:numberPositive>>] Length The length of the random string. Defaults to 8.
	@returns [t:string] The random string.
**--]]
function StringPlus.RandomString2(Length)
	assert(OptionalPositiveInteger(Length))
	local String = ""

	for _ = Length or 8, 0, -1 do
		local CharacterIndex = RandomLib:NextNumber() * 62
		CharacterIndex = CharacterIndex - CharacterIndex % 1
		String = String .. string.sub(CHARACTERS, CharacterIndex, CharacterIndex)
	end

	return String
end

--[[**
	Trims the whitespace from the front and back of the given string.
	@param [t:string] String The string you want to trim.
	@returns [t:string] The same string without leading or trailing spaces.
**--]]
function StringPlus.Trim(String)
	assert(t.string(String))
	while string.sub(String, 1, 1) == " " do
		String = string.sub(String, 2)
	end

	while string.sub(String, -1, -1) == " " do
		String = string.sub(String, 1, -2)
	end

	return String
end

--[[**
	Trims the whitespace from the front and back of the given string. This is the same as the other Trim, just slower.
	@param [t:string] String The string you want to trim.
	@returns [t:string] The same string without leading or trailing spaces.
**--]]
function StringPlus.SlowTrim(String)
	assert(t.string(String))
	return (string.gsub(String, "^%s*(.-)%s*$", "%1"))
end

--[[**
	Counts the number of times the given character appears in the string.
	@param [t:string] String The string you want to use.
	@param [t:string] Character The character you are counting.
	@returns [t:integer] The amount of times the character appears.
**--]]
function StringPlus.Count(String, Character)
	assert(CountTuple(String, Character))
	local Count = 0
	for _ in string.gmatch(String, Character) do
		Count = Count + 1
	end

	return Count
end

--[[**
	Formats a number. Example: 1000 will become "1,000".
	@param [t:union<t:string, t:number>] Number The number you want to format.
	@returns [t:string] The formatted number string.
**--]]
function StringPlus.NumberFormat(Number)
	assert(NumberOrString(Number))
	Number = "" .. Number

	local _, _, Minus, Integer, Fraction = string.find(Number, "([-]?)(%d+)([.]?%d*)")
	Integer = string.gsub(string.reverse(Integer), "(%d%d%d)", "%1,")
	return Minus .. string.gsub(string.reverse(Integer), "^,", "") .. Fraction
end

--[[**
	Checks if the given string starts with the second string.
	@param [t:string] String The string you are checking with.
	@param [t:string] StartsWith The string you are checking for.
	@param [t:optional<t:boolean>] IgnoreCase Whether or not you want to ignore the case. Defaults to false.
	@returns [t:boolean] Whether or not the string starts with the second string.
**--]]
function StringPlus.StartsWith(String, StartsWith, IgnoreCase)
	assert(StartEndWithTuple(String, StartsWith, IgnoreCase))
	IgnoreCase = IgnoreCase or false

	local Starting = string.sub(String, 1, #StartsWith)
	return IgnoreCase and string.lower(Starting) == string.lower(StartsWith) or Starting == StartsWith
end

--[[**
	Checks if the given string ends with the second string.
	@param [t:string] String The string you are checking with.
	@param [t:string] EndsWith The string you are checking for.
	@param [t:optional<t:boolean>] IgnoreCase Whether or not you want to ignore the case. Defaults to false.
	@returns [t:boolean] Whether or not the string ends with the second string.
**--]]
function StringPlus.EndsWith(String, EndsWith, IgnoreCase)
	assert(StartEndWithTuple(String, EndsWith, IgnoreCase))
	IgnoreCase = IgnoreCase or false

	local Ending = string.sub(String, -#EndsWith)
	return IgnoreCase and string.lower(Ending) == string.lower(EndsWith) or Ending == EndsWith
end

local function TitleCase(First, Rest)
	return string.upper(First) .. string.lower(Rest)
end

--[[**
	Converts the given string to TitleCase.
	@param [t:string] String The string you want to convert to TitleCase.
	@returns [t:string] The same string in TitleCase.
**--]]
function StringPlus.TitleCase(String)
	assert(t.string(String))
	return (string.gsub(String, "(%a)([%w_']*)", TitleCase))
end

return StringPlus