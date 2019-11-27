local Spritesheet = require(script.Parent.Parent.Spritesheet)

local Economy = setmetatable({
	ClassName = "Economy",
	__tostring = function()
		return "Economy"
	end,
}, Spritesheet)

Economy.__index = Economy

local ROBUX_SIZE = Vector2.new(28, 32)

function Economy.new()
	local self = setmetatable(Spritesheet.new("rbxassetid://4464986077"), Economy)

	self:addSprite("Premium", Vector2.new(5, 5), Vector2.new(28, 28))
	self:addSprite("RobuxDark", Vector2.new(43, 5), ROBUX_SIZE)
	self:addSprite("RobuxShadow", Vector2.new(81, 5), ROBUX_SIZE)
	self:addSprite("RobuxGold", Vector2.new(5, 47), ROBUX_SIZE)
	self:addSprite("RobuxLight", Vector2.new(43, 47), ROBUX_SIZE)

	return self
end

return Economy