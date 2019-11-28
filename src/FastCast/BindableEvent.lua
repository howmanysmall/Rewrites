local BindableEvent = {
	ClassName = "BindableEvent";
	__tostring = function()
		return "BindableEvent"
	end;
}

BindableEvent.__index = BindableEvent

local ipairs = ipairs

--[[**
	Creates a new BindableEvent.
	@returns [BindableEvent]
**--]]
function BindableEvent.new()
	return setmetatable({}, BindableEvent)
end

--[[**
	Fires every function in the BindableEvent with the given varargs.
	@param [t:any] ... The arguments you are firing with.
	@returns [void]
**--]]
function BindableEvent:Fire(...)
	for _, Function in ipairs(self) do
		local Thread = coroutine.create(Function)
		coroutine.resume(Thread, ...)
	end
end

--[[**
	Connects the given function to the BindableEvent.
	@param [t:callback] Function The function you are connecting.
	@returns [void]
**--]]
function BindableEvent:Connect(Function)
	self[#self + 1] = Function
end

--[[**
	Disconnects the given function from the BindableEvent.
	@param [t:callback] Function The function you are removing.
	@returns [void]
**--]]
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

--[[**
	Yields the current thread until the BindableEvent is fired.
	@returns [t:any] Whatever the BindableEvent was fired with.
**--]]
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

--[[**
	Destroys the BindableEvent object.
	@returns [void]
**--]]
function BindableEvent:Destroy()
	for Index in ipairs(self) do
		self[Index] = nil
	end

	setmetatable(self, nil)
end

return BindableEvent