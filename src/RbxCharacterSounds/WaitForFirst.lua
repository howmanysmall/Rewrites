local ipairs = ipairs

local function WaitForFirst(...)
	local BindableEvent = Instance.new("BindableEvent")
	local Fired = false
	local Connections = {}

	for Index, Signal in ipairs{...} do
		Connections[Index] = Signal:Connect(function(...)
			if not Fired then
				Fired = true
				BindableEvent:Fire(Signal, ...)

				for ConnectionIndex, Connection in ipairs(Connections) do
					Connection:Disconnect()
					Connections[ConnectionIndex] = nil
				end
			end
		end)
	end

	return BindableEvent
end

return WaitForFirst