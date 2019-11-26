local Constants = require(script.Parent.Constants)
local Types = require(script.Parent.Types)
local t = require(script.Parent.t)

local SaveData = {}
SaveData.__index = SaveData

function SaveData.new(playerDataStore, userId)
	assert(Types.saveDataTuple(playerDataStore, userId))

	local self = {
		userId = userId,
		lastSaved = 0,
		lastTouched = 0,

		dataSet = nil,
		dirtyKeySet = {},
		ownedKeySet = {},

		_locked = false,
		_unlocked = Instance.new("BindableEvent"),
		_playerDataStore = playerDataStore,
	}

	setmetatable(self, SaveData)
	return self
end

function SaveData:makeReady(data)
	self.dataSet = data
	self.lastSaved = tick()
	self._playerDataStore:markAsTouched(self)
end

function SaveData:waitForUnlocked()
	while self._locked do
		self._unlocked.Event:Wait()
	end
end

function SaveData:lock()
	self._locked = true
end

function SaveData:unlock()
	self._locked = false
	self._unlocked:Fire()
end

function SaveData:get(key)
	assert(t.string(key))

	self.ownedKeySet[key] = true
	self._playerDataStore:markAsTouched(self)

	local value = self.dataSet[key]
	if value == nil and Constants.DESERIALIZE[key] then
		local v = Constants.DESERIALIZE[key](nil)
		self.dataSet[key] = v
		return v
	else
		return value
	end
end

function SaveData:set(key, value, allowErase)
	assert(Types.setTuple(key, allowErase))

	if value == nil and not allowErase then
		error(string.format(
			"Attempt to SaveData:set(%q, nil) without allowErase == true",
			key
		), 2)
	end

	self.ownedKeySet[key] = true
	self.dirtyKeySet[key] = true
	self._playerDataStore:markAsDirty(self)

	self.dataSet[key] = value
end

--[[**
	For important atomic transactions, update DataStore. For example, for any developer product based
	purchases you should use this to ensure that the changes are saved correctly right away. Note that
	this will automatically flush any unsaved changes while doing the update.

	@param [t:table] keyList
	@param [t:callback] callback
	@returns [void]
**--]]
function SaveData:update(keyList, callback)
	assert(Types.updateTuple(keyList, callback))
	self._playerDataStore:doUpdate(self, keyList, callback)
end

--[[**
	Flush all unsaved changes out to the DataStore for this player. Note that this
	call will yield and not return until the data has actually been saved if there
	were any unsaved changes.

	@returns [void]
**--]]
function SaveData:flush()
	self._playerDataStore:doSave(self):await()
end

--[[**
	Same as flush, except returns a Promise and is asynchronous.

	@returns [Promise]
**--]]
function SaveData:flushAsync()
	return self._playerDataStore:doSaveAsync(self)
end

function SaveData:_ownKey(key)
	self.ownedKeySet[key] = true
end

function SaveData:_dirtyKey(key)
	self.dirtyKeySet[key] = true
end

function SaveData:_markAsTouched(key)
	self.ownedKeySet[key] = true
	self._playerDataStore:markAsTouched(self)
end

function SaveData:_markAsDirty(key)
	self.ownedKeySet[key] = true
	self.dirtyKeySet[key] = true
	self._playerDataStore:markAsDirty(self)
end

return SaveData