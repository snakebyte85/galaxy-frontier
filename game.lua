game_level_wait_for_enemies = false
game_level_wait_end_time = 0

function game_load_level(level)
   game_level = level
   game_level_position = 0
   game_level_checkpoint = 0
end

function game_init()
   ui_init()
   space_init()
   player:reset()
end

function game_dispose()
   space_clear() 
   particles_clear()
   enemies_clear()
   projectiles_clear()
   powerups_clear()
end

function game_level_update()

   if game_level_position < #game_level.content then

      if game_level_wait_for_enemies then
         if #enemies == 0 then
            game_level_wait_for_enemies = false
         end
      elseif time() > game_level_wait_end_time then
         game_level_position = game_level_position + 1
         local current_position = game_level.content[game_level_position]
         if #current_position == 1 and type(current_position[1]) == "number" then

            if current_position[1] < 0 then
               game_level_checkpoint = game_level_position            
            elseif current_position[1] == 0 then
               game_level_wait_for_enemies = true
            else
               game_level_wait_end_time = time() + current_position[1]
            end
         elseif #current_position == 2 and type(current_position[1]) == "function" then
            current_position[1](unpack(current_position[2]))
         elseif #current_position == 3 and type(current_position[1]) == "table" then
            current_position[1][current_position[2]](current_position[1],table_clone(current_position[3]))
         end
      end
   end
end

function game_player_dead() 
   game_level_position = game_level_checkpoint
   change_state("summary")
end

function game_update()
   game_level_update()
   ui_update()
   entities_update()
end

function game_draw()
   entities_draw()
   ui_draw()
end



