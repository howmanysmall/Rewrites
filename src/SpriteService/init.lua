local t = require(script.t)
local Spritesheets = script.Spritesheets

local SpriteService = {
	ClassName = "SpriteService";
	__tostring = function()
		return "SpriteService"
	end;
}

SpriteService.__index = SpriteService

local PublicTuple = t.tuple(t.string, t.string)
local PrivateTuple = t.tuple(t.string, t.string, t.string)

function SpriteService.new()
	return setmetatable({
		_SpritesheetCache = setmetatable({}, {
			__index = function(self, Index)
				local Spritesheet = Spritesheets:FindFirstChild(Index)

				if Spritesheet and Spritesheet:IsA("ModuleScript") then
					local Value = require(Spritesheet).new()
					self[Index] = Value
					return Value
				else
					error(string.format("Spritesheet %q doesn't exist or isn't a ModuleScript!", tostring(Index)), 3)
				end
			end;
		});
	}, SpriteService)
end

--[[**
	Returns an ImageLabel with the given sprite from the stylesheet.

	@param [t:string] SpriteName The name of the sprite in the stylesheet.
	@param [t:string] Stylesheet The stylesheet you are using.
	@returns [t:instanceOf<ImageLabel>] The ImageLabel created using a spritesheet.
**--]]
function SpriteService:GetImageLabel(SpriteName, Stylesheet)
	assert(PublicTuple(SpriteName, Stylesheet))
	return self:_GetImageInstance("ImageLabel", SpriteName, Stylesheet)
end

--[[**
	Returns an ImageButton with the given sprite from the stylesheet.

	@param [t:string] SpriteName The name of the sprite in the stylesheet.
	@param [t:string] Stylesheet The stylesheet you are using.
	@returns [t:instanceOf<ImageButton>] The ImageButton created using a spritesheet.
**--]]
function SpriteService:GetImageButton(SpriteName, Stylesheet)
	assert(PublicTuple(SpriteName, Stylesheet))
	return self:_GetImageInstance("ImageButton", SpriteName, Stylesheet)
end

--[[**
	Gets all of the spritesheets currently cached.

	@returns [t:table] All of the cached spritesheets.
**--]]
function SpriteService:GetCached()
	local Cached = {}
	local Length = 0

	for Spritesheet in next, self._SpritesheetCache do
		Length = Length + 1
		Cached[Length] = Spritesheet
	end

	return Cached
end

function SpriteService:_GetImageInstance(InstanceType, SpriteName, Stylesheet)
	assert(PrivateTuple(InstanceType, SpriteName, Stylesheet))
	local StylesheetModule = self._SpritesheetCache[Stylesheet]
	return StylesheetModule:GetSprite(InstanceType, SpriteName)
end

return SpriteService.new()