_G.Global = {}

--//VARIABLES
_G.Global.ServerAssets = game.ServerStorage.ServerAssets
_G.Global.SharedAssets = game.ReplicatedStorage.SharedAssets

--//DATA
_G.Global.PlayerData = {}
_G.Global.PlayerStates = {}

--//MODULES
_G.Global.Services = require(game.ServerStorage.Services):Init()
_G.Global.Network = require(game.ReplicatedStorage.Network)


--//LOADED
_G.Global.Loaded = false

return _G.Global