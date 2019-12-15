local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local Promise = require(script.Parent.Promise)
local t = require(script.Parent.t)

local HttpPromise = {}
local IS_SERVER = RunService:IsServer()

local OptionalString = t.optional(t.string)
local DictionaryCheck = t.keys(t.string)

local GetTuple = t.tuple(t.string, t.optional(t.boolean))

local IRequest = t.strictInterface{
	Url = t.string;
	Method = OptionalString;
	Headers = t.optional(DictionaryCheck);
	Body = OptionalString;
}

--[[**
	Used to encode a table into JSON.

	@param [t:table] Table The table you are encoding.
	@returns [Promise]
**--]]
function HttpPromise.PromiseEncode(Table)
	local TypeSuccess, TypeError = t.table(Table)
	if not TypeSuccess then
		return Promise.reject(TypeError)
	end

	return Promise.new(function(Resolve, Reject)
		local Success, Result = pcall(HttpService.JSONEncode, HttpService, Table)

		if Success then
			Resolve(Result)
		else
			Reject(Result)
		end
	end)
end

--[[**
	Used to decode a JSON string to a table.

	@param [t:string] JsonString The string you are decoding.
	@returns [Promise]
**--]]
function HttpPromise.PromiseDecode(JsonString)
	local TypeSuccess, TypeError = t.string(JsonString)
	if not TypeSuccess then
		return Promise.reject(TypeError)
	end

	return Promise.new(function(Resolve, Reject)
		local Success, Result = pcall(HttpService.JSONDecode, HttpService, JsonString)

		if Success then
			Resolve(Result)
		else
			Reject(Result)
		end
	end)
end

--[[**
	Sends an HTTP GET request to the given Url.

	@param [t:string] Url The web address you are requesting data from.
	@param [t:optional<t:boolean>] NoCache Whether the request stores (caches) the response. Defaults to false.
	@returns [Promise]
**--]]
function HttpPromise.PromiseGet(Url, NoCache)
	local TypeSuccess, TypeError = GetTuple(Url, NoCache)
	if not TypeSuccess then
		return Promise.reject(TypeError)
	end

	if not IS_SERVER then
		return Promise.reject("you cannot call PromiseGet on the client")
	end

	return Promise.async(function(Resolve, Reject)
		local Success, Response = pcall(HttpService.GetAsync, HttpService, Url, NoCache)

		if Success then
			Resolve(Response)
		else
			Reject(Response)
		end
	end)
end

--[[**
	Sends an HTTP request using a dictionary.

	@param [t:table] Request The request dictionary you are sending.
	@returns [Promise]
**--]]
function HttpPromise.PromiseRequest(Request)
	local TypeSuccess, TypeError = IRequest(Request)
	if not TypeSuccess then
		return Promise.reject(TypeError)
	end

	if not IS_SERVER then
		return Promise.reject("you cannot call PromiseRequest on the client")
	end

	return Promise.async(function(Resolve, Reject)
		local Response
		local Success, Error = pcall(function()
			Response = HttpService:RequestAsync(Request)
		end)

		if not Success then
			return Reject(Error)
		end

		if not Response.Success then
			Reject(Response)
		else
			Resolve(Response)
		end
	end)
end

--[[**
	This percent-encodes a given string so that reserved characters properly encoded with `%` and two hexadecimal characters.

	@param [t:string] EncodeString The string (URL) to encode.
	@returns [Promise]
**--]]
function HttpPromise.PromiseUrlEncode(EncodeString)
	local TypeSuccess, TypeError = t.string(EncodeString)
	if not TypeSuccess then
		return Promise.reject(TypeError)
	end

	return Promise.new(function(Resolve, Reject)
		local Success, Value = pcall(HttpService.UrlEncode, HttpService, EncodeString)

		if Success then
			Resolve(Value)
		else
			Reject(Value)
		end
	end)
end

return HttpPromise