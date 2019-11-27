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

function Timer.new(duration)
	assert(t.numberPositive(duration))

	return setmetatable({
		_isRunning = true;
		_startTime = tick();
		_duration = duration;
		_timerEvent = BindableEvent.new();
	}, Timer)
end

function Timer:start()
	assert(not self._countdown, "Timer is already running!")
	local duration = self._duration
	local startTime = self._startTime

	self._countdown = Heartbeat:Connect(function()
		local currentTime = tick() - startTime
		if currentTime > duration then
			self._isRunning = false
			self._timerEvent:fire(currentTime)
			self:stop()
		end
	end)
end

function Timer:wait()
	return self._timerEvent:wait()
end

function Timer:stop()
	if self._countdown then
		self._countdown:Disconnect()
		self._countdown = nil
	end
end

function Timer:destroy()
	if self._countdown then
		self._countdown:Disconnect()
		self._countdown = nil
	end

	self._timerEvent:destroy()
	self._timerEvent = nil
	setmetatable(self, nil)
end

return Timer