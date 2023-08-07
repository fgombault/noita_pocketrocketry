dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/pocketrocketry/data/scripts/helper.lua")
dofile_once("mods/pocketrocketry/config.lua")


function shot(entity_id)
	local explosionmodifier = getCurrentlyEquippedWandKaboom()

	local wand_id = getCurrentlyEquippedWandId()
	if (true and wand_id ~= nil and wand_id > 0) then
		local name = getNameForKaboom(explosionmodifier)
		RenameWand(wand_id, name)
	end

	local damagemodifier = 1
	if (modify_damage_values_too > 0) then
		damagemodifier = explosionmodifier
	elseif (modify_damage_values_too < 0) then
		damagemodifier = 1 / explosionmodifier
	end
	local lifetimemodifier = 1
	local speedmodifier = 1
	if (modify_lifetime_values_too > 0) then
		lifetimemodifier = explosionmodifier
	elseif (modify_lifetime_values_too < 0) then
		lifetimemodifier = 1 / explosionmodifier
	end
	-- TODO: this has to be configurable?
	speedmodifier = lifetimemodifier

	-- print("shot explosion modifier:" .. explosionmodifier)

	local comps = EntityGetComponent(entity_id, "ProjectileComponent")
	if (comps ~= nil) then
		for _, projectile in ipairs(comps) do
			local damage = ComponentGetValue2(projectile, "damage")
			damage = damage * damagemodifier
			ComponentSetValue2(projectile, "damage", damage)

			local lifetime = ComponentGetValue2(projectile, "lifetime")
			if (lifetime ~= -1) then
				lifetime = math.floor(lifetime * lifetimemodifier)
				-- pseudo wisps, is it a bad idea?
				if (lifetime <= -2 and lifetime >= -5) then lifetime = 2000 end
				ComponentSetValue2(projectile, "lifetime", lifetime)
			end
			local speed_min = ComponentGetValue2(projectile, "speed_min")
			speed_min = speed_min * speedmodifier
			ComponentSetValue2(projectile, "speed_min", speed_min)
			local speed_max = ComponentGetValue2(projectile, "speed_max")
			speed_max = speed_max * speedmodifier
			ComponentSetValue2(projectile, "speed_max", speed_max)

			local dtypes = { "projectile", "explosion", "melee", "ice", "slice", "electricity", "radioactive", "drill", "fire" }
			local damage_by_types = ComponentObjectGetMembers(projectile, "damage_by_type") or {};
			for i, damageByTypeComp in ipairs(damage_by_types) do
				for a, b in ipairs(dtypes) do
					local v = ComponentGetValue2(damageByTypeComp, b)
					v = v * damagemodifier
					ComponentSetValue2(damageByTypeComp, b, v)
				end
			end

			local etypes = { "explosion_radius", "ray_energy", "sparks_count_min", "sparks_count_max", "camera_shake",
				"damage", "material_sparks_count_min", "material_sparks_count_max", "stains_radius" }
			local explosionConfigs = ComponentObjectGetMembers(projectile, "config_explosion") or {};
			for i, explosionConfigComp in ipairs(explosionConfigs) do
				for a, b in ipairs(etypes) do
					local v = ComponentGetValue2(explosionConfigComp, b)
					v = v * damagemodifier
					ComponentSetValue2(explosionConfigComp, b, v)
				end
			end
		end
	end
end
