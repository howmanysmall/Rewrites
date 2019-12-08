local Players = game:GetService("Players")
local Signal = require(script.Signal)
local Maid = require(script.Maid)
local t = require(script.t)

local instanceWhichIsASeat = t.union(t.instanceOf("Seat"), t.instanceOf("VehicleSeat"))

local SitDetector = {
	ClassName = "SitDetector";
	__tostring = function()
		return "SitDetector"
	end;
}

SitDetector.__index = SitDetector

function SitDetector.new(seat)
	assert(instanceWhichIsASeat(seat))

	local self = setmetatable({
		_maid = Maid.new();
		currentPlayer = nil;
	}, SitDetector)

	local onSit, OnStand = self._maid:GiveTask(Signal.new(), Signal.new())

	local function ChildAdded(child)
		if child:IsA("Weld") and child.Name == "SeatWeld" and child.Part1 and child.Part1.Parent then
			local player = Players:GetPlayerFromCharacter(child.Part1.Parent)
			if player then
				self.CurrentPlayer = player
				onSit:Fire(player)
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