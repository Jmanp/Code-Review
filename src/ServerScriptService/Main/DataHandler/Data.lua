function returnData()
	local data = {
		SaveIndex = 0;
		LastSaved = tick();

		Class = 1;
		Yen = 0;
		SpecialCurrencyPLACEHOLDER = 0;

		WalkSpeed = 16;
		JumpPower = 50;
		Kills = 0;
		BossKills = 0;

		Stats = {
			Strength = {Multiplier = 1, Stat = 0};
			Durability = {Multiplier = 1, Stat = 0};
			Agility = {Multiplier = 1, Stat = 0};
			Spirit = {Multiplier = 1, Stat = 0};
			Sword = {Multiplier = 1, Stat = 0};
		};

		Weapons = {
			Equipped = 0; -- 0=Nothing Equipped
			Owned = {};
		};

		Specials = {
			Equipped = 0; -- 0=Nothing Equipped
			Owned = {};	
		};

		Heroes = {
			Slots = 0; -- 0=Nothing Equipped
			Owned = {};
		};

		Quests = {};
		Powers = {};
		Inventory = {};
	}
	
	return data
end

return returnData()
