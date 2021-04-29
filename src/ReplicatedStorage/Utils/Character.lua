local Character = {}

function Character:IsValidCharacter(instance)
	if not instance then return false end
	
	if self:FindFirstHumanoid(instance) then
		return true
	else
		return false
	end
end

function Character:IsCharacterAlive(character)
	if not character then return false end
	local humanoid = self:FindFirstHumanoid(character)
	
	if not humanoid or humanoid.Health <= 0 then return false end
	
	return true
end

function Character:FindFirstHumanoid(instance)
	if not instance then return end
	
	local humanoid
	for _, part in pairs(instance:GetChildren()) do
		if part:IsA("Humanoid") then
			humanoid = part
		end
	end
	
	if not humanoid then
		local character = instance:FindFirstAncestoryWhichIsA("Model")
		humanoid = character:FindFirstChild("Humanoid")
	end
	
	return humanoid
end

return Character
