dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/pocketrocketry/data/scripts/helper.lua")
dofile_once("mods/pocketrocketry/config.lua")


function shot( entity_id )
	local explosionmodifier = getInternalVariableValue(getPlayerEntity(), "held_wand_id", "value_int")
	SetRandomSeed(explosionmodifier, explosionmodifier)
--	explosionmodifier = RandomDistributionf(0.3, 3, 1.3)
	explosionmodifier = Randomf(0.3, 3)
	
	local damagemodifier = 1
	if modify_damage_values_too == 1 then
		damagemodifier = explosionmodifier
	end
	
	--print("shot explosion modifier:"..explosionmodifier)

	local comps = EntityGetComponent( entity_id, "ProjectileComponent" )
	if( comps ~= nil ) then
		for i,comp in ipairs(comps) do
			local damage = ComponentGetValue2( comp, "damage" )
			damage = damage * damagemodifier
			ComponentSetValue2( comp, "damage", damage )
			
			local dtypes = { "projectile", "explosion", "melee", "ice", "slice", "electricity", "radioactive", "drill", "fire" }
			for a,b in ipairs(dtypes) do
				local v = tonumber(ComponentObjectGetValue( comp, "damage_by_type", b ))
				v = v * damagemodifier
				ComponentObjectSetValue( comp, "damage_by_type", b, tostring(v) )
			end
			
			local etypes = { "explosion_radius", "ray_energy", "sparks_count_min", "sparks_count_max", "camera_shake", "damage", "material_sparks_count_min", "material_sparks_count_max", "stains_radius" }
			for a,b in ipairs(etypes) do
				local v = tonumber(ComponentObjectGetValue2( comp, "config_explosion", b ))
				v = v * explosionmodifier
				ComponentObjectSetValue( comp, "config_explosion", b, tostring(v) )
			end
		end
	end
end