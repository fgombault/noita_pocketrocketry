
function getCurrentlyEquippedWandId()
    local i2c_id = EntityGetFirstComponentIncludingDisabled(getPlayerEntity(), "Inventory2Component")
    local wand_id = ComponentGetValue2( i2c_id, "mActiveItem" )
    
    if(EntityHasTag(wand_id, "wand")) then
        return wand_id
    else
        return -1
    end
end

function getPlayerEntity()
	local players = EntityGetWithTag("player_unit")
	if #players == 0 then return end

	return players[1]
end

function testCallback()
		print("test output message")
end

function addNewInternalVariable(entity_id, variable_name, variable_type, initial_value)
    if(variable_type == "value_int") then
        EntityAddComponent2(entity_id, "VariableStorageComponent", {
            name=variable_name,
            value_int=initial_value
        })
    elseif(variable_type == "value_string") then
        EntityAddComponent2(entity_id, "VariableStorageComponent", {
            name=variable_name,
            value_string=initial_value
        })
    elseif(variable_type == "value_float") then
        EntityAddComponent2(entity_id, "VariableStorageComponent", {
            name=variable_name,
            value_float=initial_value
        })
    elseif(variable_type == "value_bool") then
        EntityAddComponent2(entity_id, "VariableStorageComponent", {
            name=variable_name,
            value_bool=initial_value
        })
    end
end

function getInternalVariableValue(entity_id, variable_name, variable_type)
    local value = nil
    local components = EntityGetComponent( entity_id, "VariableStorageComponent" )
    if ( components ~= nil ) then
        for key,comp_id in pairs(components) do 
            local var_name = ComponentGetValue2( comp_id, "name" )
            if(var_name == variable_name) then
                value = ComponentGetValue2(comp_id, variable_type)
            end
        end
    end
    return value
end

function setInternalVariableValue(entity_id, variable_name, variable_type, new_value)

    local components = EntityGetComponent( entity_id, "VariableStorageComponent" )    
    if ( components ~= nil ) then
        for key,comp_id in pairs(components) do 
            local var_name = ComponentGetValue2( comp_id, "name" )
            if( var_name == variable_name) then
                ComponentSetValue2( comp_id, variable_type, new_value )
            end
        end
    end
end

