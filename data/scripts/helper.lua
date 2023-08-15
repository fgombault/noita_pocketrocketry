function GetWandInfo(iEntityID)
    local iAbilityComp = EntityGetFirstComponentIncludingDisabled(iEntityID, "AbilityComponent")
    local aWandInfo = {}
    if iAbilityComp then
        -- print("yep, seems like a wand")
        local shuffle = ComponentObjectGetValue2(iAbilityComp, "gun_config", "shuffle_deck_when_empty")
        aWandInfo[0] = 0
        if shuffle then aWandInfo[0] = 1 end
        aWandInfo[1] = ComponentObjectGetValue2(iAbilityComp, "gun_config", "actions_per_round")
        aWandInfo[2] = ComponentObjectGetValue2(iAbilityComp, "gunaction_config", "fire_rate_wait")
        aWandInfo[3] = ComponentObjectGetValue2(iAbilityComp, "gun_config", "reload_time")
        aWandInfo[4] = ComponentGetValue2(iAbilityComp, "mana_max")
        aWandInfo[5] = ComponentGetValue2(iAbilityComp, "mana_charge_speed")
        aWandInfo[6] = ComponentObjectGetValue2(iAbilityComp, "gun_config", "deck_capacity")
        aWandInfo[7] = ComponentObjectGetValue2(iAbilityComp, "gunaction_config", "spread_degrees")
    end
    return aWandInfo
end

function Fnv1a_hash(aTable)
    local iHash = 2166136261
    for i = 1, #aTable do
        iHash = bit.bxor(iHash, aTable[i])
        iHash = bit.band(iHash * 16777619, 0xffffffff)
    end
    return iHash
end

function GetCurrentlyEquippedWandId()
    local iInventory2Comp = EntityGetFirstComponentIncludingDisabled(GetPlayerEntity(), "Inventory2Component")
    local iWandID = ComponentGetValue2(iInventory2Comp, "mActualActiveItem")

    if (EntityHasTag(iWandID, "wand")) then
        return iWandID
    end
    return nil
end

function GetCurrentlyEquippedWandSignature()
    local iWandID = GetCurrentlyEquippedWandId()
    if (iWandID ~= nil and iWandID > 0) then
        local aTable = GetWandInfo(iWandID)
        if (aTable) then
            return Fnv1a_hash(aTable)
        end
    end
    return -1
end

function GetPlayerEntity()
    local aPlayers = EntityGetWithTag("player_unit")
    if #aPlayers == 0 then return end
    return aPlayers[1]
end

function GetCurrentlyEquippedWandKaboom()
    local iSignature = GetInternalVariableValue(GetPlayerEntity(), "held_wand_hash", "value_int")
    local iSeed = tonumber(StatsGetValue("world_seed"))
    local iScale = ModSettingGet("pocketrocketry.kaboomScale") or 3
    SetRandomSeed(iSignature, iSeed)
    if ModSettingGet("pocketrocketry.kaboomDistribution") == "madhouse" then
        local f = Randomf(1, iScale)
        if (Random(1, 2) == 1) then
            return f
        else
            return 1 / f
        end
    end
    -- "normal" distribution
    local fSharpness = tonumber(ModSettingGet("pocketrocketry.kaboomDistribution")) or 1
    return RandomDistributionf(1 / iScale, iScale, 1, fSharpness)
end

function AddNewInternalVariable(iEntityID, sVariableName, sVariableType, sInitialValue)
    if (sVariableType == "value_int") then
        EntityAddComponent2(iEntityID, "VariableStorageComponent", {
            name = sVariableName,
            value_int = sInitialValue
        })
    elseif (sVariableType == "value_string") then
        EntityAddComponent2(iEntityID, "VariableStorageComponent", {
            name = sVariableName,
            value_string = sInitialValue
        })
    elseif (sVariableType == "value_float") then
        EntityAddComponent2(iEntityID, "VariableStorageComponent", {
            name = sVariableName,
            value_float = sInitialValue
        })
    elseif (sVariableType == "value_bool") then
        EntityAddComponent2(iEntityID, "VariableStorageComponent", {
            name = sVariableName,
            value_bool = sInitialValue
        })
    end
end

function GetInternalVariableValue(iEntityID, sVariableName, sVariableType)
    local sValue = nil
    local aComponents = EntityGetComponent(iEntityID, "VariableStorageComponent")
    if (aComponents ~= nil) then
        for _, iCompID in pairs(aComponents) do
            local sVarName = ComponentGetValue2(iCompID, "name")
            if (sVarName == sVariableName) then
                sValue = ComponentGetValue2(iCompID, sVariableType)
            end
        end
    end
    return sValue
end

function SetInternalVariableValue(iEntityID, sVariableName, sVariableType, sNewValue)
    local aComponents = EntityGetComponent(iEntityID, "VariableStorageComponent")
    if (aComponents ~= nil) then
        for _, iCompID in pairs(aComponents) do
            local sVarName = ComponentGetValue2(iCompID, "name")
            if (sVarName == sVariableName) then
                ComponentSetValue2(iCompID, sVariableType, sNewValue)
            end
        end
    end
end

function SetWandSpeedMult(iWandID, fSpeedMult)
    local iAbilityComp = EntityGetFirstComponentIncludingDisabled(iWandID, "AbilityComponent")
    if (ComponentGetValue2(iAbilityComp, "use_gun_script") ~= true) then return end
    local fCurrentSpeedMult = ComponentObjectGetValue2(iAbilityComp, "gunaction_config", "speed_multiplier")
    if (math.floor(fCurrentSpeedMult * 1000) == math.floor(fSpeedMult * 1000)) then return end
    ComponentObjectSetValue2(iAbilityComp, "gunaction_config", "speed_multiplier", fSpeedMult)
    -- Refresh the wand if it's being held by the player
    local iParent = EntityGetRootEntity(iWandID)
    if EntityHasTag(iParent, "player_unit") then
        local iInventory2Comp = EntityGetFirstComponentIncludingDisabled(iParent, "Inventory2Component")
        if iInventory2Comp then
            ComponentSetValue2(iInventory2Comp, "mForceRefresh", true)
            ComponentSetValue2(iInventory2Comp, "mActualActiveItem", 0)
        end
    end
end

function RenameWand(iWandID, sNewName)
    local iItemComp = EntityGetFirstComponentIncludingDisabled(iWandID, "ItemComponent")
    local iInfoComp = EntityGetFirstComponentIncludingDisabled(iWandID, "UIInfoComponent")
    local iPotionComp = EntityGetFirstComponentIncludingDisabled(iWandID, "PotionComponent")

    if iItemComp == nil or iItemComp == 0 then return end
    if iPotionComp ~= nil and iPotionComp ~= 0 then return end
    if (sNewName == nil or sNewName == "") then return end

    ComponentSetValue2(iItemComp, "item_name", sNewName)
    local uses_item_name = ComponentGetValue2(iItemComp, "always_use_item_name_in_ui")
    if not uses_item_name then
        ComponentSetValue2(iItemComp, "always_use_item_name_in_ui", true)
    end
    if iInfoComp ~= 0 and iInfoComp ~= nil then
        ComponentSetValue2(iInfoComp, "name", sNewName)
    end
end

WandNames = { "test1", "test2", "test3", "test4" }
dofile("data/scripts/names.lua")

function MapKaboomToRange(fKaboom, iRangeMax)
    SetRandomSeed(fKaboom, 0)
    return Random(1, iRangeMax)
end

function GetNameForKaboom(fKaboom)
    local sWandName = WandNames[MapKaboomToRange(fKaboom, #WandNames)]
    local sHint = ""

    if (ModSettingGet("pocketrocketry.nameHint") == "subtle") then
        local fScale = ModSettingGet("pocketrocketry.kaboomScale") or 3
        local fThresh1 = fScale / 8
        local fThresh2 = fScale / 2
        if (fKaboom > (1 + fThresh1)) then sHint = "!" end
        if (fKaboom > (1 + fThresh2)) then sHint = "!!" end
        if (fKaboom < (1 - fThresh1)) then sHint = "." end
        if (fKaboom < (1 - fThresh2)) then sHint = ".." end
    end
    if (ModSettingGet("pocketrocketry.nameHint") == "number") then
        local iPrecision = 1000
        local iRoundedK = math.floor(fKaboom * iPrecision) / iPrecision
        sHint = " " .. iRoundedK
    end

    return sWandName .. sHint
    -- return sWandName .. sHint
end
