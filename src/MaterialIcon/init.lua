local Spritesheet = require(script.MaterialSpritesheet)

local SHEET_ASSETS = {
	"rbxassetid://3926305904";
	"rbxassetid://3926307971";
	"rbxassetid://3926309567";
	"rbxassetid://3926311105";
	"rbxassetid://3926312257";
	"rbxassetid://3926313458";
	"rbxassetid://3926314806";
	"rbxassetid://3926316119";
	"rbxassetid://3926317787";
	"rbxassetid://3926319099";
	"rbxassetid://3926319860";
	"rbxassetid://3926321212";
	"rbxassetid://3926326846";
	"rbxassetid://3926327588";
	"rbxassetid://3926328650";
	"rbxassetid://3926329330";
	"rbxassetid://3926330123";
	"rbxassetid://3926333840";
	"rbxassetid://3926334787";
	"rbxassetid://3926335698";
}

local function ClosestResolution(Icon, GoalResolution)
	assert(type(Icon) == "table")
	assert(type(GoalResolution) == "number")

	local Closest = 0
	local ClosestDelta = nil

	for Resolution in next, Icon do
		if GoalResolution % Resolution == 0 or Resolution % GoalResolution == 0 then
			return Resolution
		elseif not ClosestDelta or math.abs(Resolution - GoalResolution) < ClosestDelta then
			Closest = Resolution
			ClosestDelta = math.abs(Resolution - GoalResolution)
		end
	end

	return Closest
end

-- TODO Rewrite as an object for easier use.

local function CreateIcon(Properties)
	local IconName = Properties.Icon
	local Icon = Spritesheet[IconName]
	local ChosenResolution = Properties.Resolution

	if not ChosenResolution then
		if Properties.Size.X.Scale ~= 0 or Properties.Size.Y.Scale ~= 0 then
			ChosenResolution = ClosestResolution(Icon, math.huge)
		else
			assert(Properties.Size.X.Offset == Properties.Size.Y.Offset, "If using offset Icon size must result in a square")
			ChosenResolution = ClosestResolution(Icon, Properties.Size.X.Offset)
		end
	end

	local Variant = Icon[ChosenResolution]

	local IconImage = Instance.new(Properties.Type or "ImageLabel")
	IconImage.Image = SHEET_ASSETS[Variant.Sheet]
	IconImage.BackgroundTransparency = 1
	IconImage.ImageRectSize = Vector2.new(Variant.Size, Variant.Size)
	IconImage.ImageRectOffset = Vector2.new(Variant.X, Variant.Y)
	IconImage.ImageColor3 = Properties.IconColor3
	IconImage.ImageTransparency = Properties.IconTransparency
	IconImage.Size = Properties.Size
	IconImage.Position = Properties.Position
	IconImage.AnchorPoint = Properties.AnchorPoint
	IconImage.ZIndex = Properties.ZIndex

	return IconImage
end

return CreateIcon