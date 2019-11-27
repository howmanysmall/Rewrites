local BindableEvent = {
	ClassName = "BindableEvent";
	__tostring = function()
		return "BindableEvent"
	end;
}

BindableEvent.__index = BindableEvent

local ipairs = ipairs

function BindableEvent.new()
	return setmetatable({}, BindableEvent)
end

function BindableEvent:Fire(...)
	for _, Function in ipairs(self) do
		local Thread = coroutine.create(Function)
		coroutine.resume(Thread, ...)
	end
end

function BindableEvent:Connect(Function)
	self[#self + 1] = Function
end

function BindableEvent:Disconnect(Function)
	local Length = #self

	for Index, OtherFunction in ipairs(self) do
		if OtherFunction == Function then
			self[Index] = self[Length]
			self[Length] = nil
			break
		end
	end
end

function BindableEvent:Wait()
	local Thread = coroutine.running()

	local function Yield(...)
		local Length = #self

		for Index, OtherFunction in ipairs(self) do
			if OtherFunction == Yield then
				self[Index] = self[Length]
				self[Length] = nil
				break
			end
		end

		coroutine.resume(Thread, ...)
	end

	self[#self + 1] = Yield
	return coroutine.yield()
end

function BindableEvent:Destroy()
	for Index in ipairs(self) do
		self[Index] = nil
	end

	setmetatable(self, nil)
end

return BindableEvent