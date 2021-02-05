function summary_init()

   ui_init()

   if player.lives > 0 then
      create_timer(3,function()
                      change_state("game")
      end)
   else
      create_timer(3,function()
                      change_state("title","wipe_to_black_to_state")
      end)
   end
end

function summary_dispose()

end

function summary_update()

end

function summary_draw()

   ui_draw()

   if player.lives > 0 then
      print(game_level.name, 45, 50, const.colors.white)
      spr(1, 48, 78)
      print(" x "..player.lives, 55,80, const.colors.white)
   else
      print("game over", 45, 50, const.colors.white)
   end   
end
