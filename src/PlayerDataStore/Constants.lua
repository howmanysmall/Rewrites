local Symbol = require(script.Parent.Symbol)

return {
	CACHE_EXPIRY_TIME = 60*10,
	PASSIVE_SAVE_FREQUENCY = 60*1,
	PASSIVE_GRANULARITY = 5,

	SERIALIZE = {},
	DESERIALIZE = {},

	DATASTORE_NAME = "PlayerDataStore_PlayerData_RELEASE00",
	SAVE_ON_LEAVE = true,

	Delete = Symbol.named("Delete"),
}