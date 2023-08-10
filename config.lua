-- set this to 1 if you want wand damage to be affected by the explosion size multiplier.
-- set this to -1 if you want wand damage to be inversely affected by it
-- modify_damage_values_too = 1
-- modify_lifetime_values_too = 1

-- example: only modify explosion radius, but not damage or lifetime
-- modify_damage_values_too = 0
-- modify_lifetime_values_too = 0

-- example: when radius and damage are increased, lifetime is reduced. dangerous! funny!
modify_damage_values_too = 1
modify_lifetime_values_too = -1

-- example: only modifies radius and damage, leave lifetime out of it
-- modify_damage_values_too = 1
-- modify_lifetime_values_too = 0

-- FIXME: implement type "none"
if ModSettingGet("modificationType") == "explosion only" then
	modify_damage_values_too = 0
	modify_lifetime_values_too = 0
end
if ModSettingGet("modificationType") == "full" then
	modify_damage_values_too = 1
	modify_lifetime_values_too = -1
end
