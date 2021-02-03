space={
   speed_y=1,
   stars_count=50,
   stars={},
   planets={}
}

function create_star(x,y)

   local distance = rnd(1)
   local color = const.colors.white
   if distance > 0.8 then
      color=const.colors.dark_gray
   elseif distance > 0.4 then
      color=const.colors.light_gray
   end
   local speed = space.speed_y * (1-distance)

   particle_class:new({
         x=x or flr(rnd(127)),
         y=y or 0,
         speed=speed,
         direction=const.direction.down,
         color=color,
         init=function(self)
            particle_class.init(self)
            add(space.stars,self)
         end,
         dispose=function(self)
            particle_class.dispose(self)
            del(space.stars,self)
            create_star()
         end
   })

end

particle_planet_class=particle_class:new_class({
      speed=space.speed_y * 0.05,
      direction=const.direction.down,
      init=function(self)
         particle_class.init(self)
         add(space.planets,self)
      end,
      dispose=function(self)
         particle_class.dispose(self)
         del(space.planets,self)
         create_star()
      end
})

particle_earth_class=particle_planet_class:new_class({      
      sprite_number=65,
      sprite_offset={x=-8,y=-8},
      sprite_size={w=2,h=2}
})

particle_moon_class=particle_planet_class:new_class({
      speed=space.speed_y * 0.05,
      direction=const.direction.down,
      sprite_number=97,
      sprite_offset={x=-8,y=-8},
      sprite_size={w=2,h=2}
})

particle_jupiter_class=particle_planet_class:new_class({
      speed=space.speed_y * 0.05,
      direction=const.direction.down,
      sprite_number=67,
      sprite_offset={x=-16,y=-16},
      sprite_size={w=4,h=4}
})

particle_sun_class=particle_planet_class:new_class({      
      speed=0,
      sprite_number=71,
      sprite_offset={x=-16,y=-16},
      sprite_size={w=4,h=4}
})

particle_supernova_class=particle_sun_class:new_class({
      draw=function(self)
         pal(const.colors.yellow, const.colors.blue)
         pal(const.colors.orange, const.colors.dark_blue)
         particle_sun_class.draw(self)
         pal()
      end
})


function space_init()
   for i=1,space.stars_count do
      create_star(flr(rnd(127)), flr(rnd(127)))
   end   
end

