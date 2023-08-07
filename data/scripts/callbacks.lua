function addNewLuaCallback(entity_id, callback_type, script_path, frames_between_runs, remove_after_executed, tag)
    local lc_id = nil
    if(callback_type == "overtime") then
        lc_id = EntityAddComponent2(entity_id, "LuaComponent", {
            script_source_file=script_path,
            execute_every_n_frame=frames_between_runs,
            remove_after_executed=remove_after_executed
        })
    elseif(callback_type == "on_collision") then
        lc_id = EntityAddComponent2(entity_id, "LuaComponent", {
            script_collision_trigger_hit=script_path,
            execute_every_n_frame=frames_between_runs,
            remove_after_executed=remove_after_executed
        })
    elseif(callback_type == "on_damaged") then
        lc_id = EntityAddComponent2(entity_id, "LuaComponent", {
            script_damage_received=script_path,
            execute_every_n_frame=frames_between_runs,
            remove_after_executed=remove_after_executed
        })
    elseif(callback_type == "on_death") then
        lc_id = EntityAddComponent2(entity_id, "LuaComponent", {
            script_death=script_path,
            execute_every_n_frame=frames_between_runs,
            remove_after_executed=remove_after_executed
        })
    elseif(callback_type == "on_projectile_shot") then
        lc_id = EntityAddComponent2(entity_id, "LuaComponent", {
            script_shot=script_path,
            execute_every_n_frame=frames_between_runs,
            remove_after_executed=remove_after_executed
        })
    elseif(callback_type == "on_kick") then
        lc_id = EntityAddComponent2(entity_id, "LuaComponent", {
            script_kick=script_path,
            execute_every_n_frame=frames_between_runs,
            remove_after_executed=remove_after_executed
        })
    end
    ComponentAddTag(lc_id, tag)
end
