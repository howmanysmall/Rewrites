local t = require(script.Parent.t)

local Spritesheet = {
	ClassName = "Spritesheet";
	__tostring = function()
		return "Spritesheet"
	end;
}

Spritesheet.__index = Spritesheet

local AssetId = t.union(t.intersection(t.integer, t.numberPositive), t.match("%d+"))
local AddSpriteTuple = t.tuple(t.string, t.Vector2, t.Vector2)
local GetSpriteTuple = t.tuple(t.intersection(t.match("^Image"), t.union(t.match("Button$"), t.match("Label$"))), t.string)

--[[**
	Creates a new Spritesheet.

	@param [t:union<t:intersection<t:integer, t:numberPositive>, t:match<%d+>>] Texture The asset texture of the spritesheet.
	@returns [Spritesheet] The new Spritesheet class.
**--]]
function Spritesheet.new(Texture)
	assert(AssetId(Texture))

	return setmetatable({
		_Texture = type(Texture) == "number" and "rbxassetid://" .. Texture or Texture;
		_Sprites = {};
	}, Spritesheet)
end

--[[**
	Adds a new sprite to the Spritesheet.

	@param [t:string] SpriteName The name of the sprite.
	@param [t:Vector2] Position The Vector2 position of the sprite on the spritesheet image.
	@param [t:Vector2] Size The Vector2 size of the sprite on the spritesheet image.
	@returns [void]
**--]]
function Spritesheet:AddSprite(SpriteName, Position, Size)
	assert(AddSpriteTuple(SpriteName, Position, Size))
	self._Sprites[SpriteName] = {Position = Position, Size = Size}
end

--[[**
	Creates a new Instance with the given sprite SpriteName.

	@param [t:string] InstanceType The type of Instance you want to create. Either ImageLabel or ImageButton.
	@param [t:string] SpriteName The name of the sprite you are creating.
	@returns [t:instanceOf<InstanceType>] The new Instance.
**--]]
function Spritesheet:GetSprite(InstanceType, SpriteName)
	assert(GetSpriteTuple(InstanceType, SpriteName))
	local Sprite = self._Sprites[SpriteName]

	if Sprite then
		local Element = Instance.new(InstanceType)
		Element.BackgroundTransparency = 1
		Element.Image = self._Texture
		Element.Size = UDim2.fromOffset(Sprite.Size.X, Sprite.Size.Y)
		Element.ImageRectOffset = Sprite.Position
		Element.ImageRectSize = Sprite.Size
		return Element
	else
		error(string.format("Could not find a sprite with the name %q.", SpriteName), 3)
	end
end

return Spritesheet