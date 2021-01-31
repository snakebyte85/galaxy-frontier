space={
   speed_x=0,
   speed_y=1,
   stars_count=50,
   stars={}
}

function create_star()
      return {
         x=0,
         y=0,
         distance=0         
      }
end

function space_init()
   for i=1,space.stars_count do
      local star = create_star()
      star.x = flr(rnd(127))
      star.y = flr(rnd(127))
      star.distance=rnd(1)
      add(space.stars,star)
   end   
end

function space_draw()

   for star in all(space.stars) do
      local color = const.colors.white
      if star.distance>0.8 then
         color=const.colors.dark_gray
      end
      pset(star.x,star.y,color)
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

   for i=1,#stars_to_delete do
      local star = create_star()
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
   
end
