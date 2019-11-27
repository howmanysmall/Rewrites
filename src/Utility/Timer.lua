local RunService = game:GetService("RunService")
local BindableEvent = require(script.Parent.BindableEvent)
local t = require(script.Parent.t)

local Heartbeat = RunService.Heartbeat

local Timer = {
	ClassName = "Timer";
	__tostring = function()
		return "Timer"
	end;
}

Timer.__index = Timer

function Timer.new(Duration)
	assert(t.numberPositive(Duration))

	return setmetatable({
		IsRunning = true;
		StartTime = tick();
		Duration = Duration;
		TimerEvent = BindableEvent.new();
	}, Timer)
end

function Timer:Start()
	assert(not self.Countdown, "Timer is already running!")
	local Duration = self.Duration
	local StartTime = self.StartTime

	self.Countdown = Heartbeat:Connect(function()
		local CurrentTime = tick() - StartTime
		if CurrentTime > Duration then
			self.IsRunning = false
			self.TimerEvent:Fire(CurrentTime)
			self:Stop()
		end
	end)
end

function Timer:Wait()
	return self.TimerEvent:Wait()
end

function Timer:Stop()
	if self.Countdown then
		self.Countdown:Disconnect()
		self.Countdown = nil
	end
end

function Timer:Destroy()
	if self.Countdown then
		self.Countdown:Disconnect()
		self.Countdown = nil
	end

	self.TimerEvent:Destroy()
	self.TimerEvent = nil
	setmetatable(self, nil)
end

return Timer