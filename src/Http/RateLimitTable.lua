-- _G is bad!!

local RateLimitTable = {}

function RateLimitTable:__index(Index)
	return self[Index]
end

function RateLimitTable:__newindex(Index, Value)
	self[Index] = Value
end

function RateLimitTable:Free(Index)
	if rawget(self, Index) then
		rawset(self, Index, nil)
	end
end

return RateLimitTable