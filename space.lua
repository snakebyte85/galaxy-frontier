space={
   speed_x=0,
   speed_y=1,
   stars_count=50,
   stars={},
   planets={}
}

function create_star()
   star = {
      x=0,
      y=0,
      distance=0         
   }

   if space.speed_x == 0 then
      star.x = flr(rnd(127))
      if space.speed_y > 0 then
         star.y = 0
      else
         star.y = const.screen.max_y
      end
   elseif space.speed_y == 0 then
      star.y = flr(rnd(127))
      if space.speed_x > 0 then
         star.x = 0
      else
         star.x = const.screen.max_x
      end
   else 
      star.x = flr(rnd(127))
      star.y = flr(rnd(127))
   end

   star.distance=rnd(1)
   add(space.stars,star)
end

function create_planet(ttype)
   planet = {
      x=0,
      y=0,
      ttype=ttype
   }

   if space.speed_x == 0 then
      planet.x = flr(rnd(127))
      if space.speed_y > 0 then
         planet.y = -16
      else
         planet.y = const.screen.max_y + 16
      end
   elseif space.speed_y == 0 then
      planet.y = flr(rnd(127))
      if space.speed_x > 0 then
         planet.x = -16
      else
         planet.x = const.screen.max_x + 16
      end
   else 
      planet.x = flr(rnd(127))
      planet.y = flr(rnd(127))
   end  
   add(space.planets,planet)
end

function space_init()
   for i=1,space.stars_count do
      local star = {}
      star.x = flr(rnd(127))
      star.y = flr(rnd(127))
      star.distance=rnd(1)
      add(space.stars,star)
   end   
   
   create_planet("jupiter")
end

function space_draw()

   for star in all(space.stars) do
      local color = const.colors.white
      if star.distance>0.8 then
         color=const.colors.dark_gray
      end
      pset(star.x,star.y,color)
   end

   for planet in all(space.planets) do
      if planet.ttype=="earth" then         
         spr(65,planet.x-8,planet.y-8,2,2)
      elseif planet.ttype=="moon" then
         spr(97,planet.x-8,planet.y-8,2,2)
      elseif planet.ttype=="jupiter" then
         spr(67,planet.x-16,planet.y-16,4,4)
      end
   end
end


function space_update()

   local stars_to_delete = {}

   for i,star in ipairs(space.stars) do
      star.x = star.x + (space.speed_x * (1-star.distance))
      star.y = star.y + (space.speed_y * (1-star.distance))

      if star.x > const.screen.max_x or star.x < 0 or         
         star.y > const.screen.max_y or star.y < 0 then
         add(stars_to_delete, i)
      end
   end

   for i in all(stars_to_delete) do
      deli(space.stars,i)
   end

   if #space.stars < space.stars_count then
      for i=1,space.stars_count-#space.stars do
         create_star()      
      end
   end

   local planets_to_delete = {}

   for i,planet in ipairs(space.planets) do
      planet.x = planet.x + (space.speed_x * 0.05)
      planet.y = planet.y + (space.speed_y * 0.05)

      if planet.x > const.screen.max_x + 16 or planet.x < -32 or         
         planet.y > const.screen.max_y + 16 or planet.y < -32 then
         add(planets_to_delete, i)
      end
   end

   for i in all(planets_to_delete) do
      deli(space.planets,i)
   end
   
end
