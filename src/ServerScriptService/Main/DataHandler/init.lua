local DataHandler = {}

--[[
	DataHandler
	Written By: OneLegitDev
	
	DataHandler:LoadData(player, joining)
	- Arguments:
		- player
			- PlayerObject of who you want to load data for
		- joining
			- OPTIONAL: Boolean which if set true will indicate the player is first joining the server and to over-ride any existing
			- cached data and force load data without any datastore limits
	- Description:
		- Loads the data for the player specified in argument 1 using a combination of DataStore and OrderedDataStore to grab
		- the players most recent save file. After the data is retrieved it caches it in Global.PlayerData under the users UserId
		
		
	DataHandler:SaveData(player, leaving)
	- Arguments:
		- player
			- PlayerObject of who you want to save data for
		- leaving
			- OPTIONAL: Boolean which if set to tue will indicate the player is leaving the server and to clear the data-cache
			- as well as force a data save without any datastore limits
	- Description:
		- Saves the data for the player specified in argument 1 using a combination of DataStore and OrederedDataStore to save
		- the players currently cached data from Global.PlayerData under their UserId. This saves their core data under Datastore
		- however also saves a reference to the save in an OrderedDataStore to allow for data recovery and multiple save files
	
	
	DataHandler:CreateData(player)
	- Arguments
		- player
			- PlayerObject of who you want to create data for
	- Description:
		- Creates a new data table based on the default data stored in the modulescript "Data" under this script and
		- sets it to Global.PlayerData under the users UserID and returns said table
		
		
	DataHandler:GetData(player, scope)
	- Arguments
		- player
			- PlayerObject of whos data you want to return
		- scope
			- OPTIONAL: String value which can be specified if you want a specified scope to be returned only from said data
	- Description:
		- Returns the player arguments data from Global.PlayerData with the optional scope paraemeter which can be used to only return
		- a specific scope of the table
	
	
	DataHandler:IncrementValue(player, valueKey, increment)
	- Arguments
		- player
			- PlayerObject of who you want to increment a data value for
		- valueKey
			- String which is used to indetify what value you would like to change based on the keys name
			- Can be used in multi layer tables and will find and use the first value by the name it finds
		- increment
			- Number which is used to add onto/subtract from the keys value, can be either positive to increase the value or
			- negative to decrease the value
	- Description:
		- A function used to incrementing a certain keys value in the Global.PlayerData[player.UserId] table assuming the value is a Number object
]]--

--//Global
local Global = _G.Global

--//Services
local DataStoreServce = game:GetService("DataStoreService")

--//Modules
local Time = require(game.ReplicatedStorage.Utils.Time)
local Table = require(game.ReplicatedStorage.Utils.Table)

--//Variables
local dataVersion = "1.4"
local defaultData = require(script.Data)

--//Functions
function DataHandler:LoadData(player, joining)
	local dsKey = player.UserId..dataVersion
	local dataKeys = {}

	local orderedDataStore = DataStoreServce:GetOrderedDataStore("PlayerData"..dataVersion, player.UserId)
	local dataVersions = orderedDataStore:GetSortedAsync(false, 100)
	local currentPage = dataVersions:GetCurrentPage()

	for entry, data in pairs(currentPage) do
		table.insert(dataKeys, data.key)
	end

	local playerData

	if #dataKeys == 0 then
		warn("No Data found, player is new, generating new Data")
		playerData = self:CreateData(player)

		Global.PlayerData[player.UserId].Loaded = true

		return true, Global.PlayerData[player.UserId]
	else
		local dataStore = DataStoreServce:GetDataStore("PlayerData"..dsKey)
		playerData = dataStore:GetAsync(dataKeys[1])

		if playerData then
			Global.PlayerData[player.UserId] = playerData
			Global.PlayerData[player.UserId].Loaded = true

			return true, Global.PlayerData[player.UserId]
		else
			warn("Data was nil, data loading failed, do not attempt to save")
			if Global.PlayerData[player.UserId] then
				Global.PlayerData[player.UserId].Loaded = false
			else
				Global.PlayerData[player.UserId] = {}
				Global.PlayerData[player.UserId].Loaded = false
			end

			return false
		end
	end
end

function DataHandler:SaveData(player, leaving)
	if not player or not player.UserId then return false end

	local playerData = Global.PlayerData[player.UserId]
	if not playerData or not playerData.Loaded then return false end
	if (tick() - playerData.LastSaved) < 120 and (not leaving) then return false end

	local dsKey = player.UserId..dataVersion
	local dataKey = "SaveData: "..Time:GetFormattedDate(os.date("!*t"))

	local orderedDataStore = DataStoreServce:GetOrderedDataStore("PlayerData"..dataVersion, player.UserId)
	local dataStore = DataStoreServce:GetDataStore("PlayerData"..dsKey)

	playerData.LastSaved = tick()
	playerData.SaveIndex += 1

	dataStore:SetAsync(dataKey, playerData)
	orderedDataStore:SetAsync(dataKey, playerData.SaveIndex)

	print("PlayerData Saved")
end

function DataHandler:CreateData(player)
	if not player or not player.UserId then return end

	local dataTable = Table.deepCopy(defaultData)
	Global.PlayerData[player.UserId] = dataTable

	return Global.PlayerData[player.UserId]
end

function DataHandler:GetData(player, scope)
	if type(player) == "string" then
		player = game.Players:FindFirstChild(player)
	end

	if not player then return end
	if not Global.PlayerData[player.UserId] then return end

	if scope then
		return Global.PlayerData[player.UserId][scope]
	else
		return Global.PlayerData[player.UserId]
	end
end

function DataHandler:IncrementValue(player, valueKey, increment)
	if type(player) == "string" then
		player = game.Players:FindFirstChild(player)
	end

	if not player then return false end
	if not Global.PlayerData[player.UserId] then return false end

	local setSuccess = Table.recursiveValueIncrement(Global.PlayerData[player.UserId], valueKey, increment)
	if setSuccess then
		return true
	end

	return false
end

return DataHandler