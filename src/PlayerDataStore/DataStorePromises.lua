local Promise = require(script.Parent.Promise)
local Types = require(script.Parent.Types)

local DataStorePromises = {}

function DataStorePromises.updateAsync(robloxDataStore, key, callback)
	assert(Types.updateAsyncTuple(robloxDataStore, key, callback))

	return Promise.async(function(resolve, reject)
		local result
		local success, error = pcall(function()
			result = table.pack(robloxDataStore:UpdateAsync(key, callback))
		end)

		if not success then
			return reject(error)
		end

		if not result then
			return reject("Got no result")
		end

		return resolve(table.unpack(result, 1, result.n))
	end)
end

function DataStorePromises.getAsync(robloxDataStore, key)
	assert(Types.getAsyncTuple(robloxDataStore, key))

	return Promise.async(function(resolve, reject)
		local result
		local success, error = pcall(function()
			result = robloxDataStore:GetAsync(key)
		end)

		if not success then
			return reject(error)
		end

		return resolve(result)
	end)
end

function DataStorePromises.setAsync(robloxDataStore, key, value)
	assert(Types.setAsyncTuple(robloxDataStore, key, value))

	return Promise.async(function(resolve, reject)
		local success, error = pcall(robloxDataStore.SetAsync, robloxDataStore, key, value)
		if not success then
			return reject(error)
		end

		return resolve(true)
	end)
end

function DataStorePromises.removeAsync(robloxDataStore, key)
	assert(Types.getAsyncTuple(robloxDataStore, key))

	return Promise.async(function(resolve, reject)
		local success, error = pcall(robloxDataStore.RemoveAsync, robloxDataStore, key)
		if not success then
			return reject(error)
		end

		return resolve(true)
	end)
end

return DataStorePromises