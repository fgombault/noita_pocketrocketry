dofile_once("mods/pocketrocketry/data/scripts/helper.lua");

local playerwandid = getInternalVariableValue(getPlayerEntity(), "held_wand_id", "value_int")
local heldwandid = getCurrentlyEquippedWandId()

function shot( projectile_entity_id )
	heldwandid = getCurrentlyEquippedWandId()
--	print("Internal player ID:"..playerwandid)
--	print("Held wand ID:"..heldwandid)
	setInternalVariableValue(getPlayerEntity(), "held_wand_id", "value_int", heldwandid)
	
end
