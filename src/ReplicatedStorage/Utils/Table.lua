local module = {}

function module.clone(tbl)
    local result = {}
    for key, value in pairs(tbl) do
        result[key] = value
    end
    return result
end

function module.deepCopy(tbl)
    local newTable = {}

    for key, value in pairs(tbl) do
        if typeof(value) == "table" then
            newTable[key] = module.deepCopy(value)
        else
            newTable[key] = value
        end
    end

    return newTable
end

function module.recursiveFind(tbl, keyToFind)
	for key, value in pairs(tbl) do
		if key == keyToFind then
			return key, value
		end

		if typeof(value) == "table" then
			local foundKey, foundValue = module.recursiveFind(value, keyToFind)
			if foundKey ~= nil then
				return foundKey, foundValue
			end
		end
	end
	
	return nil
end

function module.recursiveValueSet(tbl, keyToFind, newValue)
	for key, value in pairs(tbl) do
		if key == keyToFind then
			tbl[key] = newValue
			return true
		end

		if typeof(value) == "table" then
			local setSuccess = module.recursiveValueSet(value, keyToFind, newValue)
			if setSuccess == true then
				return setSuccess
			end
		end
	end

	return false
end

function module.recursiveValueIncrement(tbl, keyToFind, increment)
	for key, value in pairs(tbl) do
		if key == keyToFind then
			if type(value) == "number" then
				tbl[key] = value + increment
				return true
			end
		end

		if typeof(value) == "table" then
			local setSuccess = module.recursiveValueIncrement(value, keyToFind, increment)
			if setSuccess == true then
				return setSuccess
			end
		end
	end

	return false
end

return module