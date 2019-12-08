local Players = game:GetService("Players")
local Signal = require(script.Signal)
local Maid = require(script.Maid)
local t = require(script.t)

local InstanceWhichIsASeat = t.union(t.instanceOf("Seat"), t.instanceOf("VehicleSeat"))

local SitDetector = {
	ClassName = "SitDetector";
	__tostring = function()
		return "SitDetector"
	end;
}

SitDetector.__index = SitDetector

function SitDetector.new(Seat)
	assert(InstanceWhichIsASeat(Seat))

	local self = setmetatable({
		Maid = Maid.new();
		CurrentPlayer = nil;
	}, SitDetector)

	local OnSit, OnStand = self.Maid:GiveTask(Signal.new(), Signal.new())

	local function ChildAdded(Child)
		if Child:IsA("Weld") and Child.Name == "SeatWeld" and Child.Part1 and Child.Part1.Parent then
			local Player = Players:GetPlayerFromCharacter(Child.Part1.Parent)
			if Player then
				self.CurrentPlayer = Player
				OnSit:Fire(Player)
			end
		end
	end

	local function ChildRemoved(Child)
		if Child:IsA("Weld") and Child.Name == "SeatWeld" and Child.Part1 and Child.Part1.Parent then
			local Player = Players:GetPlayerFromCharacter(Child.Part1.Parent)
			if Player then
				self.CurrentPlayer = nil
				OnStand:Fire(Player)
			end
		end
	end

	self.Maid:GiveTask(Seat.ChildAdded:Connect(ChildAdded), Seat.ChildRemoved:Connect(ChildRemoved))
	self.OnSit = OnSit
	self.OnStand = OnStand

	return self
end

function SitDetector:Destroy()
	self.Maid:Destroy()
	setmetatable(self, nil)
end

return SitDetector