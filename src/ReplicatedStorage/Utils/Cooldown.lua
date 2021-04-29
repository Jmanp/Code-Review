local Cooldown = {}

--[[
	Cooldown
	Written By: OneLegitDev
	
	Cooldown:CreateCooldown(player, id, length)
	- Arguments:
		- player
			- PlayerObject OR String which identifies the index of the cooldown. Can be set to "Global" to be a global wide cooldown
		- id
			- String which indentifies the ID of the cooldown
		- length
			- OPTIONAL: Number in seconds which defines how long the cooldown will last, leave blank for permanent cooldown
	- Description:
		- Used to apply a either a player or global cooldown for debounces or ability/transformation cooldowns.
		
	
	Cooldown:RemoveCooldown(player, id, removeDelay)
	- Arguments:
		- player
			- PlayerObject OR String which identifies the index of the cooldown. Can be set to "Global" to be a global wide cooldown
		- id
			- String which indentifies the ID of the cooldown
		- removeDelay
			- OPTIONAL: Number in seconds which delays the removal of said cooldown
	- Description:
		- Used to remove either a player or global cooldown with the optional parameter to delay the removal in seconds.
		
	
	Cooldown:ClearCooldowns(player, removeDelay)
	- Arguments:
		- player
			- PlayerObject OR String which identifies the index of the cooldown. Can be set to "Global" to be a global wide cooldown
		- removeDelay
			- OPTIONAL: Number in seconds which delays the clearing of cooldowns
	- Description:
		- Used to clear all existing cooldowns from said player or Global with the optional parameter to delay the removal in seconds
		
	
	Cooldown:IsOnCooldown(player, id)
	- Arguments:
		- player
			- PlayerObject OR String which identifies the index of the cooldown. Can be set to "Global" to be a global wide cooldown
		- id
			- String which indentifies the ID of the cooldown
	- Description:
		- Checks if player/Global is on cooldown and returns a boolean based on if it is/isn't. Will also remove cooldown if it has expired
]]--

Cooldown.CooldownIndex = {
	Global = {};
}

function Cooldown:CreateCooldown(player, id, length)
	if (not player) or (not id) then return false end
	
	local cooldownInfo = {
		Player = player or "Global";
		ID = id;
		Length = length;
		StartTime = os.time();
	}
	
	if not self.CooldownIndex[player] then
		self.CooldownIndex[player] = {}
	end
	
	self.CooldownIndex[player][id] = cooldownInfo
	
	return self.CooldownIndex[player][id]
end

function Cooldown:RemoveCooldown(player, id, removeDelay)
	if self.CooldownIndex[player] then
		if tonumber(removeDelay) then
			wait(tonumber(removeDelay))
		end
		
		self.CooldownIndex[player][id] = nil
	end	
end

function Cooldown:ClearCooldowns(player, removeDelay)
	if tonumber(removeDelay) then
		wait(tonumber(removeDelay))
	end
	
	self.CooldownIndex[player] = {}
end

function Cooldown:IsOnCooldown(player, id)
	if not self.CooldownIndex[player] then return false end
	if not self.CooldownIndex[player][id] then return false end
	if not self.CooldownIndex[player][id].StartTime then return false end
	
	if self.CooldownIndex[player][id].Length ~= nil then
		if os.time() - self.CooldownIndex[player][id].StartTime >= self.CooldownIndex[player][id].Length then
			self.CooldownIndex[player][id] = nil
			return false
		end
	end
	
	return true
end

return Cooldown
