function getWandInfo(entity)
    local ability_comp = EntityGetFirstComponentIncludingDisabled(entity, "AbilityComponent")
    local wand_info = {}
    if ability_comp then
        -- print("yep, seems like a wand")
        local shuffle = ComponentObjectGetValue2(ability_comp, "gun_config", "shuffle_deck_when_empty")
        wand_info[0] = 0
        if shuffle then wand_info[0] = 1 end
        wand_info[1] = ComponentObjectGetValue2(ability_comp, "gun_config", "actions_per_round")
        wand_info[2] = ComponentObjectGetValue2(ability_comp, "gunaction_config", "fire_rate_wait")
        wand_info[3] = ComponentObjectGetValue2(ability_comp, "gun_config", "reload_time")
        wand_info[4] = ComponentGetValue2(ability_comp, "mana_max")
        wand_info[5] = ComponentGetValue2(ability_comp, "mana_charge_speed")
        wand_info[6] = ComponentObjectGetValue2(ability_comp, "gun_config", "deck_capacity")
        wand_info[7] = ComponentObjectGetValue2(ability_comp, "gunaction_config", "spread_degrees")
    end
    return wand_info
end

function fnv1a_hash(table)
    local hash = 2166136261
    for i = 1, #table do
        hash = bit.bxor(hash, table[i])
        hash = bit.band(hash * 16777619, 0xffffffff)
    end
    return hash
end

function getCurrentlyEquippedWandId()
    local i2c_id = EntityGetFirstComponentIncludingDisabled(getPlayerEntity(), "Inventory2Component")
    local wand_id = ComponentGetValue2(i2c_id, "mActualActiveItem")

    if (EntityHasTag(wand_id, "wand")) then
        return wand_id
    end
    return nil
end

function getCurrentlyEquippedWandHash()
    local wand_id = getCurrentlyEquippedWandId()
    if (wand_id ~= nil and wand_id > 0) then
        local tab = getWandInfo(wand_id)
        if (tab) then
            return fnv1a_hash(tab)
        end
    end
    return -1
end

function getPlayerEntity()
    local players = EntityGetWithTag("player_unit")
    if #players == 0 then return end
    return players[1]
end

function getCurrentlyEquippedWandKaboom()
    local signature = getInternalVariableValue(getPlayerEntity(), "held_wand_hash", "value_int")
    local seed = tonumber(StatsGetValue("world_seed"))
    SetRandomSeed(signature, seed)
    local explosionmodifier = RandomDistributionf(0.3, 3, 1)
    -- local explosionmodifier = Randomf(0.5, 2)
    return explosionmodifier
end

function addNewInternalVariable(entity_id, variable_name, variable_type, initial_value)
    if (variable_type == "value_int") then
        EntityAddComponent2(entity_id, "VariableStorageComponent", {
            name = variable_name,
            value_int = initial_value
        })
    elseif (variable_type == "value_string") then
        EntityAddComponent2(entity_id, "VariableStorageComponent", {
            name = variable_name,
            value_string = initial_value
        })
    elseif (variable_type == "value_float") then
        EntityAddComponent2(entity_id, "VariableStorageComponent", {
            name = variable_name,
            value_float = initial_value
        })
    elseif (variable_type == "value_bool") then
        EntityAddComponent2(entity_id, "VariableStorageComponent", {
            name = variable_name,
            value_bool = initial_value
        })
    end
end

function getInternalVariableValue(entity_id, variable_name, variable_type)
    local value = nil
    local components = EntityGetComponent(entity_id, "VariableStorageComponent")
    if (components ~= nil) then
        for key, comp_id in pairs(components) do
            local var_name = ComponentGetValue2(comp_id, "name")
            if (var_name == variable_name) then
                value = ComponentGetValue2(comp_id, variable_type)
            end
        end
    end
    return value
end

function setInternalVariableValue(entity_id, variable_name, variable_type, new_value)
    local components = EntityGetComponent(entity_id, "VariableStorageComponent")
    if (components ~= nil) then
        for key, comp_id in pairs(components) do
            local var_name = ComponentGetValue2(comp_id, "name")
            if (var_name == variable_name) then
                ComponentSetValue2(comp_id, variable_type, new_value)
            end
        end
    end
end

function RenameWand(wand, new_name)
    local item_component = EntityGetFirstComponentIncludingDisabled(wand, "ItemComponent")
    local info_component = EntityGetFirstComponentIncludingDisabled(wand, "UIInfoComponent")
    local potion_component = EntityGetFirstComponentIncludingDisabled(wand, "PotionComponent")

    if item_component == nil or item_component == 0 then return end
    if potion_component ~= nil and potion_component ~= 0 then return end

    local current_name = ComponentGetValue2(item_component, "item_name") or ""

    if (new_name == nil or new_name == "") then return end
    if string.lower(new_name) == string.lower(current_name) then return end
    if (current_name == "" or current_name == "wand") then
        ComponentSetValue2(item_component, "item_name", new_name)

        local uses_item_name = ComponentGetValue2(item_component, "always_use_item_name_in_ui")
        if not uses_item_name then
            ComponentSetValue2(item_component, "always_use_item_name_in_ui", true)
        end

        if info_component ~= 0 and info_component ~= nil then
            ComponentSetValue2(info_component, "name", new_name)
        end
        GamePrint("I shall call you: " .. new_name)
    end
    -- print("renamed wand: " .. name)
end

WandNames = { "test1", "test2", "test3", "test4" }
dofile("data/scripts/names.lua")

function mapKaboomToRange(kaboom, rangemax)
    SetRandomSeed(kaboom, 0)
    return Random(1, rangemax)
end

function getNameForKaboom(kaboom)
    local wandname = WandNames[mapKaboomToRange(kaboom, #WandNames)]
    -- local rounded_k = math.floor(kaboom * 10) / 10
    local hint = ""
    if (kaboom > 1.2) then hint = "!" end
    if (kaboom > 2) then hint = "!!" end
    if (kaboom < 0.8) then hint = "." end
    if (kaboom < 0.5) then hint = ".." end

    return wandname .. hint
end
