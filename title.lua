function title_init()
   title_exiting = false
   space_init()
   particle_sun_class:new({x=20,y=20})
end

function title_dispose()
   space_clear()
end

function title_update()
   particles_update()
   if title_exiting == false and (btn(const.input.o) or btn(const.input.z)) then
      title_exiting = true
      player.lives=3
      game_load_level(level_galaxy1)
      change_state("summary", "wipe_to_black")      
   end
end

function title_draw()
   particles_draw()
   print("galaxy frontier", 30, 50, const.colors.white)
   print("press \142 or \151 to start", 20,80, const.colors.white)
end
