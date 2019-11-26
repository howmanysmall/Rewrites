local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local Constants = require(script.Parent.Constants)
local DataStorePromises = require(script.Parent.DataStorePromises)
local SaveData = require(script.Parent.SaveData)
local Promise = require(script.Parent.Promise)
local Types = require(script.Parent.Types)
local t = require(script.Parent.t)

assert(RunService:IsServer(), "Cannot use DataStores on the client!")

local WEAK_VALUE = {__mode = "v"}

local function deepCopy(table)
	if type(table) == "table" then
		local new = {}
		for index, value in pairs(table) do
			new[index] = deepCopy(value)
		end

		return new
	else
		return table
	end
end

local spawnEvent = Instance.new("BindableEvent")
spawnEvent.Event:Connect(function(callback, argumentsCallback)
	callback(argumentsCallback())
end)

local function fastSpawn(callback, ...)
	assert(t.callback(callback))
	local arguments = table.pack(...)

	spawnEvent:Fire(callback, function()
		return table.unpack(arguments, 1, arguments.n)
	end)
end

local PlayerDataStore = {}
PlayerDataStore.__index = PlayerDataStore

function PlayerDataStore.new(keyPrefix)
	assert(Types.optionalString(keyPrefix))
	keyPrefix = keyPrefix or "PlayerData"

	local self = {
		_dataStore = DataStoreService:GetDataStore(Constants.DATASTORE_NAME),

		_userIdSaveDataCache = setmetatable({}, WEAK_VALUE),
		_touchedSaveDataCacheSet = {},
		_onlinePlayerSaveDataMap = {},
		_dirtySaveDataSet = {},
		_onRequestUserIdSet = {},

		_requestCompleted = Instance.new("BindableEvent"),
		_closeEvents = {},
		_firedBools = {},

		_savingCount = 0,
		_keyPrefix = keyPrefix,
	}

	setmetatable(self, PlayerDataStore)
	self:_handlePlayers()
	return self
end

function PlayerDataStore.getInitialData()
	return {}
end

function PlayerDataStore.collectDataToSave(saveData)
	assert(Types.instanceOfClassSaveData(saveData))
	local collected = {}

	for key in pairs(saveData.dirtyKeySet) do
		local value = saveData.dataSet[key]

		if value ~= nil then
			if Constants.SERIALIZE[key] then
				collected[key] = Constants.SERIALIZE[key](value)
			else
				collected[key] = deepCopy(value)
			end
		else
			collected[key] = Constants.Delete
		end

		saveData.dirtyKeySet[key] = nil
	end

	return collected
end

function PlayerDataStore:getSaveData(player)
	assert(Types.player(player))
	return self:_doLoad(player.UserId)
end

function PlayerDataStore:getSaveDataById(userId)
	assert(Types.userId(userId))
	return self:_doLoad(userId)
end

function PlayerDataStore:flushAll()
	local savesRunning = 0
	local complete = Instance.new("BindableEvent")

	for saveData in pairs(self._dirtySaveDataSet) do
		fastSpawn(function()
			savesRunning = savesRunning + 1
			self:doSave(saveData)
			savesRunning = savesRunning - 1
			if savesRunning <= 0 then
				complete:Fire()
			end
		end)
	end

	if savesRunning > 0 then
		complete.Event:Wait()
	end

	complete:Destroy()
end

PlayerDataStore.flushAllAsync = Promise.promisify(PlayerDataStore.flushAll)

function PlayerDataStore:markAsTouched(saveData)
	assert(Types.instanceOfClassSaveData(saveData))
	self._touchedSaveDataCacheSet[saveData] = true
	saveData.lastTouched = tick()
	self._userIdSaveDataCache[saveData.userId] = saveData
end

function PlayerDataStore:markAsDirty(saveData)
	assert(Types.instanceOfClassSaveData(saveData))
	self._touchedSaveDataCacheSet[saveData] = true
	saveData.lastTouched = tick()
	self._userIdSaveDataCache[saveData.userId] = saveData
	self._dirtySaveDataSet[saveData] = true
end

function PlayerDataStore:_getKey(saveData)
	assert(Types.instanceOfClassSaveData(saveData))
	return self._keyPrefix .. saveData.userId
end

function PlayerDataStore:doSave(saveData)
	assert(Types.instanceOfClassSaveData(saveData))
	saveData.lastSaved = tick()
	self._dirtySaveDataSet[saveData] = nil

	if next(saveData.dirtyKeySet) then
		local collected = PlayerDataStore.collectDataToSave(saveData)

		saveData:waitForUnlocked()
		saveData:lock()
		self._savingCount = self._savingCount + 1

		DataStorePromises.updateAsync(self._dataStore, self._keyPrefix .. saveData.userId, function(oldData)
			if not oldData then
				oldData = PlayerDataStore.getInitialData()
			end

			for key, data in pairs(collected) do
				if data == Constants.Delete then
					oldData[key] = nil
				else
					oldData[key] = data
				end
			end

			return oldData
		end):andThen(function()
			print("player", saveData.userId, "data saved")
		end):catch(function(error)
			warn("error on doSave!", error)
		end):finally(function()
			self._savingCount = self._savingCount - 1
			saveData:unlock()
		end)
	end
end

PlayerDataStore.doSaveAsync = Promise.promisify(PlayerDataStore.doSave)

function PlayerDataStore:doUpdate(saveData, keyList, callback)
	assert(Types.doUpdateTuple(saveData, keyList, callback))

	saveData:waitForUnlocked()
	saveData:lock()
	self._savingCount = self._savingCount + 1

	saveData.lastSaved = tick()
	self._dirtySaveDataSet[saveData] = nil

	local updateKeySet = {}
	for _, key in ipairs(keyList) do
		saveData.ownedKeySet[key] = true
		updateKeySet[key] = true
	end

	local collected = PlayerDataStore.collectDataToSave(saveData)
	DataStorePromises.updateAsync(self._dataStore, self._keyPrefix .. saveData.userId, function(oldData)
		if not oldData then
			oldData = PlayerDataStore.getInitialData()
		end

		local valueList = {}
		for index, key in ipairs(keyList) do
			local value = saveData.dataSet[key]
			if value == nil and Constants.DESERIALIZE[key] then
				valueList[index] = Constants.DESERIALIZE[key](nil)
			else
				valueList[index] = value
			end
		end

		local results = table.pack(callback(table.unpack(valueList, 1, #keyList)))

		for index, result in ipairs(results) do
			local key = keyList[index]
			if Constants.SERIALIZE[key] then
				oldData[key] = Constants.SERIALIZE[key](result)
			else
				oldData[key] = result
			end

			saveData.dataSet[key] = result
		end

		for key, data in pairs(collected) do
			if not updateKeySet[key] then
				if data == Constants.Delete then
					oldData[key] = nil
				else
					oldData[key] = data
				end
			end
		end

		return oldData
	end):andThen(function()
		print("player", saveData.userId, "data updated")
	end):catch(function(error)
		warn("error on doUpdate!", error)
	end):finally(function()
		self._savingCount = self._savingCount - 1
		saveData:unlock()
	end)
end

PlayerDataStore.doUpdateAsync = Promise.promisify(PlayerDataStore.doUpdate)

function PlayerDataStore:_doLoad(userId)
	assert(Types.userId(userId))
	local saveData = self._userIdSaveDataCache[userId]

	if saveData then
		self:markAsTouched(saveData)
		return saveData
	end

	if self._onRequestUserIdSet[userId] then
		while true do
			saveData = self._requestCompleted.Event:Wait()()
			if saveData.userId == userId then
				self:markAsTouched(saveData)
				return saveData
			end
		end
	else
		self._onRequestUserIdSet[userId] = true
		local getDataEvent = Instance.new("BindableEvent")

		DataStorePromises.getAsync(self._dataStore, self._keyPrefix .. userId):andThen(function(result)
			print("player", userId, "got data")
			return result or {Name = "Hi"}
		end):catch(function(error)
			warn("error on _doLoad!", error)
		end):finally(function(result)
			getDataEvent:Fire(result)
		end)

		local data = getDataEvent.Event:Wait()
		for key, value in pairs(data) do
			if Constants.DESERIALIZE[key] then
				data[key] = Constants.DESERIALIZE[key](value)
			end
		end

		saveData = SaveData.new(self, userId)
		saveData:makeReady(data)
		self:markAsTouched(saveData)

		self._onRequestUserIdSet[userId] = nil
		self._requestCompleted:Fire(function()
			return saveData
		end)

		return saveData
	end
end

function PlayerDataStore:_handlePlayer(player)
	assert(Types.player(player))
	local saveData = self:_doLoad(player.UserId)

	if player.Parent then
		self._onlinePlayerSaveDataMap[player] = saveData

		if not self._closeEvents[player] then
			self._closeEvents[player] = Instance.new("BindableEvent")
			self._firedBools[player] = false
		end
	end
end

function PlayerDataStore:_handlePlayerLeaving(player)
	assert(Types.player(player))

	if self._onlinePlayerSaveDataMap[player] and self._closeEvents[player] then
		local connection
		connection = player.AncestryChanged:Connect(function()
			if player:IsDescendantOf(game) then
				return
			end

			connection:Disconnect()
			connection = nil

			local oldSaveData = self._onlinePlayerSaveDataMap[player]
			self._onlinePlayerSaveDataMap[player] = nil

			if oldSaveData then
				self:doSaveAsync(oldSaveData):andThen(function()
					print("player", player.Name, "left, saved their data.")
				end):catch(function(error)
					warn("error when player left!", error)
				end):finally(function()
					self._closeEvents[player]:Fire()
					self._firedBools[player] = true
				end)
			end

			delay(40, function()
				if self._closeEvents[player] then
					self._closeEvents[player]:Destroy()
					self._closeEvents[player] = nil
				end

				if self._firedBools[player] ~= nil then
					self._firedBools[player] = nil
				end
			end)
		end)
	end
end

function PlayerDataStore:_handlePlayers()
	local function playerAdded(player)
		self:_handlePlayer(player)
	end

	local function playerRemoving(player)
		self:_handlePlayerLeaving(player)
	end

	Players.PlayerAdded:Connect(playerAdded)
	Players.PlayerRemoving:Connect(playerRemoving)

	for _, player in ipairs(Players:GetPlayers()) do
		playerAdded(player)
	end

	game:BindToClose(function()
		for _, player in ipairs(Players:GetPlayers()) do
			if self._closeEvents[player] and self._firedBools[player] == false then
				fastSpawn(function()
					player.Parent = nil
				end)

				self._closeEvents[player].Event:Wait()
			end
		end

		self:flushAllAsync():andThen(function()
			print("flushAllAsync called!")
		end):catch(function(error)
			warn("flushAllAsync failed!", error)
		end)
	end)

	fastSpawn(function()
		while true do
			self:_removeTimedOutCacheEntries()
			self:_passiveSaveUnsavedChanges()
			wait(Constants.PASSIVE_GRANULARITY)
		end
	end)
end

function PlayerDataStore:_removeTimedOutCacheEntries()
	local currentTime = tick()

	for saveData in pairs(self._touchedSaveDataCacheSet) do
		if currentTime - saveData.lastTouched > Constants.CACHE_EXPIRY_TIME then
			if self._dirtySaveDataSet[saveData] then
				self:doSaveAsync(saveData):andThen(function()
					print("player", saveData.userId, "data saved")
				end):catch(function(error)
					warn("error on _removeTimedOutCacheEntries!", error)
				end)
			else
				self._touchedSaveDataCacheSet[saveData] = nil
			end
		end
	end
end

function PlayerDataStore:_passiveSaveUnsavedChanges()
	local currentTime = tick()

	for saveData in pairs(self._dirtySaveDataSet) do
		if currentTime - saveData.lastSaved > Constants.PASSIVE_SAVE_FREQUENCY then
			self:doSaveAsync(saveData):andThen(function()
				print("player", saveData.userId, "data saved")
			end):catch(function(error)
				warn("error on _removeTimedOutCacheEntries!", error)
			end)
		end
	end
end

return PlayerDataStore