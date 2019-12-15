local Promise = require(script.Parent.Promise)
local t = require(script.Parent.t)

local Utility = {}

local PagesInstance = t.instanceOf("Pages")

function Utility.PagesToArray(Pages)
	assert(PagesInstance(Pages))
	local Array = {}
	local Length = 0

	while true do
		for _, Value in ipairs(Pages:GetCurrentPage()) do
			Length = Length + 1
			Array[Length] = Value
		end

		if Pages.IsFinished then
			break
		end

		Pages:AdvanceToNextPageAsync()
	end

	return Array
end

return Utility