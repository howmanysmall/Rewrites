-- Light-weight, flexible object for cleaning up connections, instances, etc.
-- @documentation https://rostrap.github.io/Libraries/Events/Janitor/
-- @author Validark

local RunService = game:GetService("RunService")
local Heartbeat = RunService.Heartbeat

local LinkToInstanceIndex = newproxy(false)
local Janitors = setmetatable({}, {__mode = "k"})

local Janitor = {__index = {CurrentlyCleaning = true}}

local TypeDefaults = {
	["function"] = true;
	["RBXScriptConnection"] = "Disconnect";
}

local BindableEvent = Instance.new("BindableEvent")
BindableEvent.Event:Connect(function(Function, Arguments)
	Function(Arguments())
end)

local function FastSpawn(Function, ...)
	local Arguments = table.pack(...)
	BindableEvent:Fire(Function, function()
		return table.unpack(Arguments, 1, Arguments.n)
	end)
end

local next = next

local function Wait(YieldTime)
	local GoalTime = tick() + YieldTime
	while tick() <= GoalTime do
		Heartbeat:Wait()
	end
end

function Janitor.new()
	return setmetatable({CurrentlyCleaning = false}, Janitor)
end

function Janitor.__index:Add(Object, MethodName, Index)
	if Index then
		self:Remove(Index)

		local this = Janitors[self]

		if not this then
			this = {}
			Janitors[self] = this
		end

		this[Index] = Object
	end

	self[Object] = MethodName or TypeDefaults[typeof(Object)] or "Destroy"
	return Object
end

function Janitor.__index:Remove(Index)
	local this = Janitors[self]

	if this then
		local Object = this[Index]

		if Object then
			local MethodName = self[Object]

			if MethodName then
				if MethodName == true then
					Object()
				else
					Object[MethodName](Object)
				end

				self[Object] = nil
			end

			this[Index] = nil
		end
	end
end

function Janitor.__index:Cleanup()
	if not self.CurrentlyCleaning then
		self.CurrentlyCleaning = nil -- A little trick to exclude the Debouncer from the loop below AND set it to true via __index :)

		for Object, MethodName in next, self do
			if MethodName == true then
				Object()
			else
				Object[MethodName](Object)
			end

			self[Object] = nil
		end

		local this = Janitors[self]

		if this then
			for Index in next, this do
				this[Index] = nil
			end

			Janitors[self] = nil
		end

		self.CurrentlyCleaning = false
	end
end

function Janitor.__index:Destroy()
	self:Cleanup()
	setmetatable(self, nil)
end

Janitor.__call = Janitor.__index.Cleanup

--- Makes the Janitor clean up when the instance is destroyed
-- @param Instance Instance The Instance the Janitor will wait for to be Destroyed
-- @returns Disconnectable table to stop Janitor from being cleaned up upon Instance Destroy (automatically cleaned up by Janitor, btw)
-- @author Corecii
local Disconnect = {Connected = true}
Disconnect.__index = Disconnect

function Disconnect:Disconnect()
	self.Connected = false
	self.Connection:Disconnect()
end

function Janitor.__index:LinkToInstance(Object, AllowMultiple)
	local Reference = Instance.new("ObjectValue")
	Reference.Value = Object

	local ManualDisconnect = setmetatable({}, Disconnect)
	local Connection

	local function ChangedFunction(Obj, Par)
		if not Reference.Value then
			ManualDisconnect.Connected = false
			return self:Cleanup()
		elseif Obj == Reference.Value and not Par then
			Obj = nil
			Wait()

			if (not Reference.Value or not Reference.Value.Parent) and ManualDisconnect.Connected then
				if not Connection.Connected then
					ManualDisconnect.Connected = false
					return self:Cleanup()
				else
					while true do
						Wait(0.2)
						if not ManualDisconnect.Connected then
							return
						elseif not Connection.Connected then
							ManualDisconnect.Connected = false
							return self:Cleanup()
						elseif Reference.Value.Parent then
							return
						end
					end
				end
			end
		end
	end

	Connection = Object.AncestryChanged:Connect(ChangedFunction)
	ManualDisconnect.Connection = Connection
	Object = nil
	FastSpawn(ChangedFunction, Reference.Value, Reference.Value.Parent)

	if AllowMultiple then
		self:Add(ManualDisconnect, "Disconnect")
	else
		self:Add(ManualDisconnect, "Disconnect", LinkToInstanceIndex)
	end

	return ManualDisconnect
end

return Janitor.new