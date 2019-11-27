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

return FastSpawn