local t = require(script.Parent.t)

local Signal = {
	ClassName = "Signal";
	__tostring = function()
		return "Signal"
	end;
}

Signal.__index = Signal

--[[**
	Creates a new Signal.
	@returns [Signal]
**--]]
function Signal.new()
	return setmetatable({
		BindableEvent = Instance.new("BindableEvent");
--		Functions = {};
	}, Signal)
end

--[[**
	Fires every function in the Signal with the given varargs.
	@param [t:optional<t:any>] ... The arguments you are firing with.
	@returns [void]
**--]]
function Signal:Fire(...)
	local Arguments = table.pack(...)

	self.BindableEvent:Fire(function()
		return table.unpack(Arguments, 1, Arguments.n)
	end)
end

--[[**
	Connects the given function to the Signal.
	@param [t:callback] Function The function you are connecting.
	@returns [t:RBXScriptConnection] The connection of the Signal's BindableEvent.
**--]]
function Signal:Connect(Function)
	assert(t.callback(Function))

	local RBXScriptConnection = self.BindableEvent.Event:Connect(function(Arguments)
		assert(t.callback(Arguments))
		Function(Arguments())
	end)

--	self.Functions[Function] = RBXScriptConnection
	return RBXScriptConnection
end

--[[**
	Yields the current thread until the Signal is fired.
	@returns [t:optional<t:any>] Whatever the Signal was fired with, if there is anything.
**--]]
function Signal:Wait()
	return self.BindableEvent.Event:Wait()()
end

--[=[
--[[**
	Disconnects the given function from the Signal.
	@param [t:callback] Function The function you are removing.
	@returns [void]
**--]]
function Signal:Disconnect(Function)
	assert(t.callback(Function))

	for OtherFunction, Connection in next, self.Functions do
		if Function == OtherFunction then
			Connection:Disconnect()
			self.Functions[OtherFunction] = nil
		end
	end
end
--]=]

--[[**
	Destroys the Signal.
	@returns [void]
**--]]
function Signal:Destroy()
	self.BindableEvent = self.BindableEvent:Destroy()
--	self.Functions = {}
--	self.Functions = nil
	setmetatable(self, nil)
end

return Signal