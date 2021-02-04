function title_init()
   space_init()
   particle_sun_class:new({x=20,y=110})
end

function title_update()
   particles_update()
   if btn(const.input.o) or btn(const.input.z) then
      change_state("game", "wipe_to_black")
   end
end

function title_draw()
   particles_draw()
   print("galaxy frontier", 30, 50, const.colors.white)
   print("press \142 or \151 to start", 20,80, const.colors.white)
end
