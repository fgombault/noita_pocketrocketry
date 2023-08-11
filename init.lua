dofile_once("mods/pocketrocketry/data/scripts/callbacks.lua");
dofile_once("mods/pocketrocketry/data/scripts/helper.lua");

local worldseed = 0

function OnWorldInitialized()
	print("pocketrocketry initialized!")
	SetRandomSeed(StatsGetValue("world_seed"), StatsGetValue("world_seed"))
	worldseed = StatsGetValue("world_seed")
end

function OnPlayerSpawned(player)
	if (GetInternalVariableValue(player, "held_wand_hash", "value_int") == nil) then
		AddNewInternalVariable(player, "held_wand_hash", "value_int", 1)
		AddNewLuaCallback(player, "on_projectile_shot", "mods/pocketrocketry/data/scripts/playershotlistener.lua", 10, false,
			"playershotlistener")
		EntityAddComponent(player, "LuaComponent",
			{
				script_shot = "mods/pocketrocketry/data/scripts/fauxglasscannon.lua",
				execute_every_n_frame = "-1",
			})
	end
end
