dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/pocketrocketry/data/scripts/helper.lua")


function shot(iEntityID)
	local fExplosionModifier = getCurrentlyEquippedWandKaboom()
	-- INFO: less damage variation for balance
	local fDamageModifier = fExplosionModifier ^ 0.7
	-- INFO: more variation in speed values, as per play testing
	local fSpeedModifier = (1 / fExplosionModifier)

	if ModSettingGet("pocketrocketry.modificationType") == "explosion only" then
		fSpeedModifier = 1
		fDamageModifier = 1
	end
	if ModSettingGet("pocketrocketry.modificationType") == "none" then
		fSpeedModifier = 1
		fDamageModifier = 1
		fExplosionModifier = 1
	end

	local iWandID = getCurrentlyEquippedWandId()
	if (iWandID ~= nil and iWandID > 0) then
		if (ModSettingGet("pocketrocketry.wandNames") ~= "don't rename") then
			local sName = getNameForKaboom(fExplosionModifier)
			RenameWand(iWandID, sName)
		end
		-- This doesn't affect the first shot, surprise for the player?
		SetWandSpeedMult(iWandID, fSpeedModifier)
	end

	-- print("shot explosion modifier:" .. explosionmodifier)

	local aProjComps = EntityGetComponent(iEntityID, "ProjectileComponent")
	if (aProjComps ~= nil) then
		for _, iProjectile in ipairs(aProjComps) do
			local iDamage = ComponentGetValue2(iProjectile, "damage")
			iDamage = iDamage * fDamageModifier
			ComponentSetValue2(iProjectile, "damage", iDamage)

			local aDamTypes = { "projectile", "explosion", "melee", "ice", "slice",
				"electricity", "radioactive", "drill", "fire" }
			local aDamageByTypesComps = ComponentObjectGetMembers(iProjectile, "damage_by_type") or {}
			for _, iDamageByTypeComp in ipairs(aDamageByTypesComps) do
				for _, iDamType in ipairs(aDamTypes) do
					local fDamValue = ComponentGetValue2(iDamageByTypeComp, iDamType)
					fDamValue = fDamValue * fDamageModifier
					ComponentSetValue2(iDamageByTypeComp, iDamType, fDamValue)
				end
			end

			local aExplTypes = { "explosion_radius", "ray_energy", "sparks_count_min",
				"sparks_count_max", "camera_shake", "damage",
				"material_sparks_count_min", "material_sparks_count_max", "stains_radius" }
			local explosionConfigs = ComponentObjectGetMembers(iProjectile, "config_explosion") or {}
			for _, explosionConfigComp in ipairs(explosionConfigs) do
				for _, iExplType in ipairs(aExplTypes) do
					local fExplValue = ComponentGetValue2(explosionConfigComp, iExplType)
					fExplValue = fExplValue * fExplosionModifier
					ComponentSetValue2(explosionConfigComp, iExplType, fExplValue)
				end
			end
		end
	end
end
