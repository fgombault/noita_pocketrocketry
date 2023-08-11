dofile_once("mods/pocketrocketry/data/scripts/helper.lua");

-- local playerwandhash = getInternalVariableValue(getPlayerEntity(), "held_wand_hash", "value_int")
local iHeldWandSignature = GetCurrentlyEquippedWandSignature()

function shot(iProjectileEntityID)
	iHeldWandSignature = GetCurrentlyEquippedWandSignature()
	SetInternalVariableValue(GetPlayerEntity(), "held_wand_hash", "value_int", iHeldWandSignature)
end
