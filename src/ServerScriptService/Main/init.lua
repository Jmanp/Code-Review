--[[
    CLASH FRAMEWORK
    MADE BY: OneLegitDev
--]]

local Global = require(script.Global)

--//Services
local Network = Global.Network
local DataHandler = require(script.DataHandler)

--//Modules

--//Variables

--//Functions

--[[
	Player Added
	- Runs all intial setup for when a player first joins the game including:
		- Loading players data and creating a cache under "Global.PlayerData[userId]"
		- Sets up PlayerStateData table
]]--

local function playerAdded(player)
	local dataLoaded, playerData = DataHandler:LoadData(player, true)
	print(playerData)
end

--[[
	Player Removing
	- Runs all functions needed for when a player leaves the game including:
		- Saving players data and clearing the cache under "Global.PlayerData[userId]"
		- Clearing players PlayerStateData table
]]--

local function playerRemoving(player)
	DataHandler:SaveData(player, true)
end


--Linking of the events to functions for PlayerAdded and PlayerRemoving
game:GetService("Players").PlayerAdded:Connect(playerAdded)
game:GetService("Players").PlayerRemoving:Connect(playerRemoving)

--Wait 5 seconds before completely shutting down server to allow for players data to save.
game:BindToClose(function()
	wait(5)
end)