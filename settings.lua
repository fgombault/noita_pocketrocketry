dofile("data/scripts/lib/mod_settings.lua")


local mod_id = "pocketrocketry" -- This should match the name of your mod's folder.
mod_settings_version = 1        -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value.
mod_settings =
{
	{
		id = "kaboomDistribution",
		ui_name = "Distribution curve",
		ui_description = "Normal for serious runs, madhouse if you don't care for your safety",
		value_default = "madhouse",
		values = { { "1.5", "Narrow" }, { "0.8", "Varied" }, { "madhouse", "Madhouse" } },
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "kaboomScale",
		ui_name = "Maximum scaling",
		ui_description = "Maximum multiplier of explosion radius",
		value_default = 3,
		value_min = 1,
		value_max = 10,
		value_display_multiplier = 1,
		value_display_formatting = " $0.0",
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "modificationType",
		ui_name = "Wand modification type",
		ui_description = "Which attributes get modified",
		value_default = "full",
		values = { { "explosion only", "Explosion radius only" },
			{ "full",           "Explosion radius, damage and speed" },
			{ "none",           "None" } },
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "wandNames",
		ui_name = "Wand naming theme",
		ui_description = "How to rename wands after you shoot them once",
		value_default = "funny_names",
		values = { { "funny_names", "Immature Gibberish" },
			{ "colored_gods",     "Colored Gods" },
			{ "demon_sandwiches", "Demon Sandwiches" },
			{ "magic_kitchen",    "Magic Kitchen" },
			{ "toilet_finnish",   "Toilet Finnish" },
			{ "don't rename",     "Don't rename" } },
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "nameHint",
		ui_name = "Hint text in wand name",
		ui_description = "How the wand name tells you about explosion factor",
		value_default = "subtle",
		values = { { "subtle", "Subtle" }, { "number", "Number" }, { "no", "No" } },
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
}

-- This function is called to ensure the correct setting values are visible to the game via ModSettingGet(). your mod's settings don't work if you don't have a function like this defined in settings.lua.
-- This function is called:
--		- when entering the mod settings menu (init_scope will be MOD_SETTINGS_SCOPE_ONLY_SET_DEFAULT)
-- 		- before mod initialization when starting a new game (init_scope will be MOD_SETTING_SCOPE_NEW_GAME)
--		- when entering the game after a restart (init_scope will be MOD_SETTING_SCOPE_RESTART)
--		- at the end of an update when mod settings have been changed via ModSettingsSetNextValue() and the game is unpaused (init_scope will be MOD_SETTINGS_SCOPE_RUNTIME)
function ModSettingsUpdate(init_scope)
	local old_version = mod_settings_get_version(mod_id) -- This can be used to migrate some settings between mod versions.
	mod_settings_update(mod_id, mod_settings, init_scope)
end

-- This function should return the number of visible setting UI elements.
-- Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
-- If your mod changes the displayed settings dynamically, you might need to implement custom logic.
-- The value will be used to determine whether or not to display various UI elements that link to mod settings.
-- At the moment it is fine to simply return 0 or 1 in a custom implementation, but we don't guarantee that will be the case in the future.
-- This function is called every frame when in the settings menu.
function ModSettingsGuiCount()
	return mod_settings_gui_count(mod_id, mod_settings)
end

-- This function is called to display the settings UI for this mod. Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui(gui, in_main_menu)
	mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
end
