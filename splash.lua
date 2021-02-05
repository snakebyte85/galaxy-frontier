splash_title1 = "nakebyte"
splash_title2 = "games"

function splash_init()
   splash_title_letters = 0

   splash_snake={
      {8,8},
   }

   splash_waypoints={
      {28,28},
      {16,36},
      {30,30},
      {18,30},
      {18,24},
      {30,24}
   }
   splash_next_update = time() + 0.03
   splash_new_cell_count=14
end

function splash_dispose()

end

function splash_show_title()
   splash_title_letters = splash_title_letters + 1
   create_timer(0.1,function() 
                   splash_title_letters = splash_title_letters + 1
   end, {}, 13, function()
                   create_timer(1,function()
                                   change_state("title","wipe_to_black")
                   end)
   end)
end

function splash_update()

   if #splash_waypoints ~= 0 and      
      time() > splash_next_update then
      
      splash_next_update = time() + 0.03

      local first_cell = splash_snake[1]
      local next_wp = splash_waypoints[1]

      local diff_x = next_wp[1] - first_cell[1]
      local diff_y = next_wp[2] - first_cell[2]

      local new_cell = {first_cell[1], first_cell[2]}

      if diff_x ~= 0 then
         if diff_x > 0 then
            new_cell[1] = first_cell[1] + 1
         else
            new_cell[1] = first_cell[1] - 1
         end
      elseif diff_y ~= 0 then
         if diff_y > 0 then
            new_cell[2] = first_cell[2] + 1
         else
            new_cell[2] = first_cell[2] - 1
         end
      end

      if diff_x == 0 and diff_y == 0 then
         deli(splash_waypoints, 1)
         splash_new_cell_count = 7
         if #splash_waypoints == 0 then
            create_timer(1,splash_show_title)
         end
      else 
         if splash_new_cell_count == 0 then
            deli(splash_snake, #splash_snake)
         else
            splash_new_cell_count = splash_new_cell_count - 1
         end
         add(splash_snake, new_cell, 1)
      end
   end
end

function splash_draw()

   foreach(splash_snake, function(cell)
              rectfill(cell[1]*2, cell[2]*2, (cell[1]*2)+2, (cell[2]*2)+2, const.colors.green)
   end)

   if #splash_waypoints~= 0 then
      local next_wp = splash_waypoints[1]      
      local bit = flr(flr(time() / 0.5)%2)
      print(bit,next_wp[1]*2,next_wp[2]*2,const.colors.white)
   end

   print(sub(splash_title1,1,splash_title_letters), 65,70, const.colors.white)
   
   if splash_title_letters > 8 then
      print(sub(splash_title2,1,splash_title_letters-8), 55,80, const.colors.white)
   end

end
