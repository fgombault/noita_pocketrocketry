dofile_once("mods/pocketrocketry/data/scripts/helper.lua");

-- local playerwandhash = getInternalVariableValue(getPlayerEntity(), "held_wand_hash", "value_int")
local heldwandhash = getCurrentlyEquippedWandHash()

function shot(projectile_entity_id)
	heldwandhash = getCurrentlyEquippedWandHash()
	setInternalVariableValue(getPlayerEntity(), "held_wand_hash", "value_int", heldwandhash)
end
