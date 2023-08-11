dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/pocketrocketry/data/scripts/helper.lua")


function shot(iEntityID)
	local fExplosionModifier = GetCurrentlyEquippedWandKaboom()
	-- INFO: less damage variation for balance
	local fDamageModifier = fExplosionModifier ^ 0.7
	local fSpeedModifier = (1 / fExplosionModifier) ^ 0.7

	if ModSettingGet("pocketrocketry.modificationType") == "explosion only" then
		fSpeedModifier = 1
		fDamageModifier = 1
	end
	if ModSettingGet("pocketrocketry.modificationType") == "none" then
		fSpeedModifier = 1
		fDamageModifier = 1
		fExplosionModifier = 1
	end

	local iWandID = GetCurrentlyEquippedWandId()
	if (iWandID ~= nil and iWandID > 0) then
		if (ModSettingGet("pocketrocketry.wandNames") ~= "don't rename") then
			local sName = GetNameForKaboom(fExplosionModifier)
			RenameWand(iWandID, sName)
		end
		-- This doesn't affect the first shot, surprise for the player?
		SetWandSpeedMult(iWandID, fSpeedModifier)
	end

	-- print("shot explosion modifier:" .. explosionmodifier)

	local aProjComps = EntityGetComponent(iEntityID, "ProjectileComponent")
	if (aProjComps ~= nil) then
		for _, iProjectile in pairs(aProjComps) do
			local iDamage = ComponentGetValue2(iProjectile, "damage")
			iDamage = iDamage * fDamageModifier
			ComponentSetValue2(iProjectile, "damage", iDamage)

			local aDamTypes = { "projectile", "explosion", "melee", "ice", "slice",
				"electricity", "radioactive", "drill", "fire" }
			for _, sDamType in pairs(aDamTypes) do
				local fDamValue = ComponentObjectGetValue2(iProjectile, "damage_by_type", sDamType)
				if (fDamValue ~= nil) then
					fDamValue = fDamValue * fDamageModifier
					ComponentObjectSetValue2(iProjectile, "damage_by_type", sDamType, fDamValue)
				end
			end

			local aExplTypes = { "explosion_radius", "ray_energy", "sparks_count_min",
				"sparks_count_max", "camera_shake", "damage",
				"material_sparks_count_min", "material_sparks_count_max", "stains_radius" }
			for _, sExplType in pairs(aExplTypes) do
				local fExplValue = ComponentObjectGetValue2(iProjectile, "config_explosion", sExplType)
				if (fExplValue ~= nil) then
					-- game may crash if value is not an integer
					fExplValue = math.floor(fExplValue * fExplosionModifier)
					ComponentObjectSetValue2(iProjectile, "config_explosion", sExplType, fExplValue)
				end
			end
		end
	end
end
