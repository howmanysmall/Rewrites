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

function BindableEvent:fire(...)
	for _, callback in ipairs(self) do
		local thread = coroutine.create(callback)
		coroutine.resume(thread, ...)
	end
end

function BindableEvent:connect(callback)
	self[#self + 1] = callback
end

function BindableEvent:disconnect(callback)
	local length = #self

	for index, otherCallback in ipairs(self) do
		if otherCallback == callback then
			self[index] = self[length]
			self[length] = nil
			break
		end
	end
end

function BindableEvent:wait()
	local thread = coroutine.running()

	local function yield(...)
		local length = #self

		for index, otherCallback in ipairs(self) do
			if otherCallback == yield then
				self[index] = self[length]
				self[length] = nil
				break
			end
		end

		coroutine.resume(thread, ...)
	end

	self[#self + 1] = yield
	return coroutine.yield()
end

function BindableEvent:destroy()
	for index in ipairs(self) do
		self[index] = nil
	end

	setmetatable(self, nil)
end

return BindableEvent