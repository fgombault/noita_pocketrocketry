dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/pocketrocketry/data/scripts/helper.lua")
dofile_once("mods/pocketrocketry/config.lua")


function shot(iEntityID)
	local fExplosionModifier = getCurrentlyEquippedWandKaboom()

	local fDamageModifier = 1
	if (modify_damage_values_too > 0) then
		-- INFO: less variation in damage, for balance reasons
		fDamageModifier = fExplosionModifier ^ 0.7
	elseif (modify_damage_values_too < 0) then
		fDamageModifier = 1 / fExplosionModifier
	end
	local fSpeedModifier = 1
	if (modify_speed_values_too > 0) then
		fSpeedModifier = fExplosionModifier
	elseif (modify_speed_values_too < 0) then
		fSpeedModifier = 1 / fExplosionModifier
	end
	-- INFO: more variation in speed values, as per play testing
	fSpeedModifier = fSpeedModifier ^ 2

	local iWandID = getCurrentlyEquippedWandId()
	if (iWandID ~= nil and iWandID > 0) then
		if (ModSettingGet("wandNames") ~= "don't rename") then
			local sName = getNameForKaboom(fExplosionModifier)
			RenameWand(iWandID, sName)
		end
		-- TODO: toggle with settings
		-- FIXME: this doesn't affect the first shot, but it should
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
					fExplValue = fExplValue * fDamageModifier
					ComponentSetValue2(explosionConfigComp, iExplType, fExplValue)
				end
			end
		end
	end
end
