function AddNewLuaCallback(iEntityID, sCallbackType, sScriptPath, iFramesBetweenRuns, bRemoveAfterExecuted, sTag)
    local iLCID = nil
    if (sCallbackType == "overtime") then
        iLCID = EntityAddComponent2(iEntityID, "LuaComponent", {
            script_source_file = sScriptPath,
            execute_every_n_frame = iFramesBetweenRuns,
            remove_after_executed = bRemoveAfterExecuted
        })
    elseif (sCallbackType == "on_collision") then
        iLCID = EntityAddComponent2(iEntityID, "LuaComponent", {
            script_collision_trigger_hit = sScriptPath,
            execute_every_n_frame = iFramesBetweenRuns,
            remove_after_executed = bRemoveAfterExecuted
        })
    elseif (sCallbackType == "on_damaged") then
        iLCID = EntityAddComponent2(iEntityID, "LuaComponent", {
            script_damage_received = sScriptPath,
            execute_every_n_frame = iFramesBetweenRuns,
            remove_after_executed = bRemoveAfterExecuted
        })
    elseif (sCallbackType == "on_death") then
        iLCID = EntityAddComponent2(iEntityID, "LuaComponent", {
            script_death = sScriptPath,
            execute_every_n_frame = iFramesBetweenRuns,
            remove_after_executed = bRemoveAfterExecuted
        })
    elseif (sCallbackType == "on_projectile_shot") then
        iLCID = EntityAddComponent2(iEntityID, "LuaComponent", {
            script_shot = sScriptPath,
            execute_every_n_frame = iFramesBetweenRuns,
            remove_after_executed = bRemoveAfterExecuted
        })
    elseif (sCallbackType == "on_kick") then
        iLCID = EntityAddComponent2(iEntityID, "LuaComponent", {
            script_kick = sScriptPath,
            execute_every_n_frame = iFramesBetweenRuns,
            remove_after_executed = bRemoveAfterExecuted
        })
    end
    ComponentAddTag(iLCID, sTag)
end
