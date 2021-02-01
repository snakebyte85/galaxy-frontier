enemies = {}


function create_enemy_raider(x,y,waypoints) 

   local raider = {
      x=x,
      y=y,
      waypoints=waypoints,
      speed=1,
      ttype = "raider",
      update=function(self)
         enemy_update_waypoints(self)
      end,
      draw=function(self)
         spr(16, self.x-4, self.y-4)
      end
   }

   add(enemies, raider)

end

function create_enemy_drone(x,y,waypoints)

   local drone = {
      x=x,
      y=y,
      waypoints=waypoints,
      speed=1,
      ttype= "drone",
      rotated=false,
      update=function(self) 
         enemy_update_waypoints(self)
      end,
      draw=function(self)
         local sprite_number=17
         if not self.rotated then
            sprite_number = 18
         end
         spr(sprite_number, self.x-4, self.y-4)
      end
   }

   drone.timer = create_timer(2,
                              function(this) 
                                 this.rotated = not this.rotated
                              end,
                              {drone},
                              true)

   add(enemies, drone)
end

function create_enemy_frigate(x,y,waypoints)
   local frigate = {
      x=x,
      y=y,
      waypoints=waypoints,
      speed=0.5,
      ttype = "frigate",
      update=function(self)
         enemy_update_waypoints(self)
      end,
      draw=function(self)
         spr(32, self.x-12, self.y-4, 3,1)
      end
   }

   add(enemies, frigate)
end

function create_enemy_bomber(x,y,waypoints)
   local bomber = {
      x=x,
      y=y,
      waypoints=waypoints,
      speed=1,
      ttype = "bomber",
      update=function(self)
         enemy_update_waypoints(self)
      end,
      draw=function(self)
         spr(19, self.x-4, self.y-4)
      end
   }

   add(enemies, bomber)
end

function enemy_update_waypoints(enemy)

   if enemy.waypoints ~= nil and #enemy.waypoints ~= 0 then

      local next_wp_x = enemy.waypoints[1].x
      local next_wp_y = enemy.waypoints[1].y
      local next_wp_bc = enemy.waypoints[1].bc

      local mov_x = 0
      local mov_y = 0

      if abs(enemy.x - next_wp_x) <= const.delta and
         abs(enemy.y - next_wp_y) <= const.delta then
         deli(enemy.waypoints,1)
      else
         if next_wp_bc == nil then              
            local direction = atan2(next_wp_x-enemy.x, next_wp_y-enemy.y)
            local speed_to_apply = sqrt((next_wp_x-enemy.x)^2 + (next_wp_y-enemy.y)^2)
            if enemy.speed < speed_to_apply then
               speed_to_apply = enemy.speed
            end
            mov_x = speed_to_apply * cos(direction)
            mov_y = speed_to_apply * sin(direction)
         else 
            local control_point_x = next_wp_bc.x
            local control_point_y = next_wp_bc.y
            local number_of_points = next_wp_bc.num
            local waypoints_bc = calculate_waypoints_bc(enemy.x,enemy.y,
                                                        next_wp_x,next_wp_y,
                                                        control_point_x, control_point_y,
                                                        number_of_points)
            deli(enemy.waypoints,1)
            for i=1,#waypoints_bc do
               add(enemy.waypoints,waypoints_bc[i], i)
            end
         end
      end
      enemy.x = enemy.x + mov_x
      enemy.y = enemy.y + mov_y      
   end
end

function enemies_draw()
   for enemy in all(enemies) do
      enemy:draw()
      if global.debug and enemy.waypoints then
         if #enemy.waypoints ~= 0 then
            line(enemy.x, enemy.y,
                 enemy.waypoints[1].x, enemy.waypoints[1].y,
                 const.colors.red)
            for i=1,#enemy.waypoints do
               if enemy.waypoints[i+1] then
                  line(enemy.waypoints[i].x, enemy.waypoints[i].y,
                       enemy.waypoints[i+1].x, enemy.waypoints[i+1].y,
                       const.colors.red)
               end
            end
         end
      end
   end
end

function enemies_update()
   for enemy in all(enemies) do
      enemy:update()
   end
end




