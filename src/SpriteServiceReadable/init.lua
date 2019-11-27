local t = require(script.t)
local spritesheets = script.Spritesheets

local SpriteService = {
	ClassName = "SpriteService",
	__tostring = function()
		return "SpriteService"
	end,
}

SpriteService.__index = SpriteService

local publicTuple = t.tuple(t.string, t.string)
local privateTuple = t.tuple(t.string, t.string, t.string)

function SpriteService.new()
	return setmetatable({
		_spritesheetCache = setmetatable({}, {
			__index = function(self, index)
				local spritesheet = spritesheets:FindFirstChild(index)

				if spritesheet and spritesheet:IsA("ModuleScript") then
					local value = require(spritesheet).new()
					self[index] = value
					return value
				else
					error(string.format("Spritesheet %q doesn't exist or isn't a ModuleScript!", tostring(index)), 3)
				end
			end,
		}),
	}, SpriteService)
end

--[[**
	Returns an ImageLabel with the given sprite from the stylesheet.

	@param [t:string] spriteName The name of the sprite in the stylesheet.
	@param [t:string] stylesheet The stylesheet you are using.
	@returns [t:instanceOf<ImageLabel>] The ImageLabel created using a spritesheet.
**--]]
function SpriteService:getImageLabel(spriteName, stylesheet)
	assert(publicTuple(spriteName, stylesheet))
	return self:_getImageInstance("ImageLabel", spriteName, stylesheet)
end

--[[**
	Returns an ImageButton with the given sprite from the stylesheet.

	@param [t:string] spriteName The name of the sprite in the stylesheet.
	@param [t:string] stylesheet The stylesheet you are using.
	@returns [t:instanceOf<ImageButton>] The ImageButton created using a spritesheet.
**--]]
function SpriteService:getImageButton(spriteName, stylesheet)
	assert(publicTuple(spriteName, stylesheet))
	return self:_getImageInstance("ImageButton", spriteName, stylesheet)
end

--[[**
	Gets all of the spritesheets currently cached.

	@returns [t:table] All of the cached spritesheets.
**--]]
function SpriteService:getCached()
	local cached = {}
	local length = 0

	for spritesheet in pairs(self._spritesheetCache) do
		length = length + 1
		cached[length] = spritesheet
	end

	return cached
end

function SpriteService:_getImageInstance(instanceType, spriteName, stylesheet)
	assert(privateTuple(instanceType, spriteName, stylesheet))
	local stylesheetModule = self._spritesheetCache[stylesheet]
	return stylesheetModule:getSprite(instanceType, spriteName)
end

return SpriteService.new()