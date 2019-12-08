local Maid = {
	ClassName = "Maid";
	__tostring = function()
		return "Maid"
	end;
}

Maid.__index = Maid

local ipairs = ipairs

local function DestroyTask(Task)
	local TaskType = typeof(Task)
	if TaskType == "function" then
		local Thread = coroutine.create(Task)
		coroutine.resume(Thread)
	elseif TaskType == "RBXScriptConnection" then
		Task:Disconnect()
	elseif TaskType == "Instance" or (TaskType == "table" and (Task.Destroy or Task.destroy)) then
		Task:Destroy()
	end
end

function Maid.new()
	return setmetatable({
		Tasks = {};
	}, Maid)
end

function Maid:GiveTask(...)
	local Tasks = self.Tasks
	local Length = #Tasks

	for _, Task in ipairs{...} do
		Length = Length + 1
		Tasks[Length] = Task
	end

	return ...
end

function Maid:Remove(Task)
	local Tasks = self.Tasks
	local Index = table.find(Tasks, Task)

	if Index then
		Tasks[Index] = DestroyTask(Tasks[Index])
	end
end

function Maid:Cleanup()
	local Tasks = self.Tasks
	for Index = #Tasks, 1, -1 do
		Tasks[Index] = DestroyTask(Tasks[Index])
	end
end

function Maid:Destroy()
	local Tasks = self.Tasks
	for Index = #Tasks, 1, -1 do
		Tasks[Index] = DestroyTask(Tasks[Index])
	end

	setmetatable(self, nil)
end

return Maid