-- Sliding Window rate limit algorithm

-- Hybrid approach between fixed window and sliding log algorithm
-- Track a counter for each fixed window of time (typically 60 seconds)
-- When processing request, use weighted sum of previous and current window as ratelimit counter
-- If current window is 25% through, weigh previous window by 75% and use sum as counter

-- Relatively small # of data points per rate limit

local RateLimitTable = require(script.Parent.RateLimitTable)

local RateLimiter = {}
RateLimiter.__index = RateLimiter

function RateLimiter.Get(id, rate, window_size)
	local self = setmetatable({id = id}, RateLimiter)

	if not RateLimitTable[id] then
		RateLimitTable[id] = {
			windows = {};
			window_size = window_size;
			rate = rate;
		}
	end

	self.window_size = RateLimitTable[id].window_size
	self.rate = RateLimitTable[id].rate
	return self	
end

function RateLimiter:Window()
	return math.floor(tick() / self.window_size)
end

function RateLimiter:Progress()
	-- returns progress through current window
	return (tick() % self.window_size) / self.window_size
end

function RateLimiter:Increment()
	-- increment current window and return value
	local w = self:Window()

	if not RateLimitTable[self.id].windows[w] then
		RateLimitTable[self.id].windows[w] = 0
	end

	RateLimitTable[self.id].windows[w] = RateLimitTable[self.id].windows[w] + 1
	return RateLimitTable[self.id].windows[w]
end

function RateLimiter:Weighted(i)
	-- return weighted counter value with optional increment
	i = i or 0

	local p = self:Progress()
	local w = self:Window()

	local current = (RateLimitTable[self.id].windows[w] or 0) + i
	local prev = RateLimitTable[self.id].windows[w - 1] or 0

	return current * p + prev * (1 - p)
end

function RateLimiter:Consumption()
	-- returns current calculated rate consumption
	return self:Weighted() / self.rate
end

function RateLimiter:Request()
	-- checks if request will fall within ratelimit
	-- returns true if allowed, false if denied
	debug.profilebegin("ratelimit")

	if self:Weighted(1) > self.rate then
		debug.profileend()
		return false
	else
		self:Increment()
		debug.profileend()
		return true
	end
end

return RateLimiter