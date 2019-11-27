local t = require(script.Parent.t)

local Spritesheet = {
	ClassName = "Spritesheet",
	__tostring = function()
		return "Spritesheet"
	end,
}

Spritesheet.__index = Spritesheet

local assetId = t.union(t.intersection(t.integer, t.numberPositive), t.match("%d+"))
local addSpriteTuple = t.tuple(t.string, t.Vector2, t.Vector2)
local getSpriteTuple = t.tuple(t.intersection(t.match("^Image"), t.union(t.match("Button$"), t.match("Label$"))), t.string)

--[[**
	Creates a new Spritesheet.

	@param [t:union<t:intersection<t:integer, t:numberPositive>, t:match<%d+>>] texture The asset texture of the spritesheet.
	@returns [Spritesheet] The new Spritesheet class.
**--]]
function Spritesheet.new(texture)
	assert(assetId(texture))

	local self = {
		_texture = type(texture) == "number" and "rbxassetid://" .. texture or texture,
		_sprites = {},
	}

	setmetatable(self, Spritesheet)
	return self
end

--[[**
	Adds a new sprite to the Spritesheet.

	@param [t:string] spriteName The name of the sprite.
	@param [t:Vector2] position The Vector2 position of the sprite on the spritesheet image.
	@param [t:Vector2] size The Vector2 size of the sprite on the spritesheet image.
	@returns [void]
**--]]
function Spritesheet:addSprite(spriteName, position, size)
	assert(addSpriteTuple(spriteName, position, size))

	self._sprites[spriteName] = {
		Position = position,
		Size = size,
	}
end

--[[**
	Creates a new Instance with the given sprite spriteName.

	@param [t:string] instanceType The type of Instance you want to create. Either ImageLabel or ImageButton.
	@param [t:string] spriteName The name of the sprite you are creating.
	@returns [t:instanceOf<instanceType>] The new Instance.
**--]]
function Spritesheet:getSprite(instanceType, spriteName)
	assert(getSpriteTuple(instanceType, spriteName))
	local sprite = self._sprites[spriteName]

	if sprite then
		local element = Instance.new(instanceType)

		element.BackgroundTransparency = 1
		element.Image = self._texture
		element.Size = UDim2.fromOffset(sprite.Size.X, sprite.Size.Y)
		element.ImageRectOffset = sprite.Position
		element.ImageRectSize = sprite.Size

		return element
	else
		error(string.format("Could not find a sprite with the name %q.", spriteName), 3)
	end
end

return Spritesheet