enemies = {}

enemy_class = {
   x=0,
   y=0,
   waypoints={},
   speed=30,
   health=5,
   hitbox={},
   ttype=nil,
   sprite_number=nil,
   sprite_size={w=1,h=1},
   sprite_offset={x=-4,y=-4},
   enemy_timers={},
   hit=false,
   init=function(self)

   end,
   on_hit=function(self,damage) 
      self.health = self.health - damage

      if self.health <= 0 then         
         self:dead()         
      else       
         self.hit = true
         local enemy_timer = create_timer(0.1, 
                      function(this_enemy) 
                         this_enemy.hit = false
                      end,
                      {self})
         add(self.enemy_timers,enemy_timer)         
      end
   end,
   dead=function(self)      
      create_particle_explosion(self.x,self.y)
      self:dispose()
   end,
   dispose=function(self)
      for enemy_timer in all(enemy_timers) do
         stop_timer(enemy_timer)
      end
      del(enemies,self)
   end,
   update=function(self)
      update_regular_enemy(self)
   end,
   draw=function(self)
      spr(self.sprite_number, 
          self.x+self.sprite_offset.x, 
          self.y+self.sprite_offset.y,
          self.sprite_size.w,
          self.sprite_size.h)
   end,
   new=function(self,o)
      self.__index = self
      o=setmetatable(o or {}, self)
      o:init()
      add(enemies,o)
      return o
   end,
   new_class=function(self,o)
      self.__index = self
      o=setmetatable(o or {}, self)
      return o
   end
}

function update_regular_enemy(enemy)

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
            if (enemy.speed*delta_time()) < speed_to_apply then
               speed_to_apply = enemy.speed*delta_time()
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

      if (enemy.x > const.screen.max_x + 10 or enemy.x < -10 or
          enemy.y > const.screen.max_y + 10 or enemy.y < -10) then   
         enemy:dispose()
      end
   end
end

enemy_raider_class = enemy_class:new_class({
      speed=30,
      health=5,
      hitbox={x1=-4,y1=-4,x2=3,y2=2,ttype="rect"},
      ttype = "raider",
      sprite_number=16
})

enemy_drone_class= enemy_class:new_class({
      speed=20,
      health=10,
      hitbox={x1=-4,y1=-4,x2=3,y2=3,ttype="rect"},
      ttype= "drone",
      sprite_number=17,
      rotated=false,
      init=function(self)
         local timer = create_timer(2,
                                    function(this) 
                                       this.rotated = not this.rotated                                 
                                       if this.rotated then
                                          this.sprite_number = 17
                                       else
                                          this.sprite_number = 18
                                       end
                                    end,
                                    {self},
                                    true)

         add(self.timers,timer)
      end
})

enemy_frigate_class = enemy_class:new_class({
      speed=10,
      health=20,
      hitbox={x1=-10,y1=-4,x2=9,y2=2,ttype="rect"},
      ttype = "frigate",
      sprite_number=32,
      sprite_offset={x=-12,y=-4},
      sprite_size={w=3,h=1}
})


enemy_bomber_class=enemy_class:new_class({
      x=x,
      y=y,
      waypoints=waypoints,
      speed=20,
      health=9,
      hitbox={x1=-4,y1=-4,x2=3,y2=3,ttype="rect"},
      ttype = "bomber",
      sprite_number=19
})

function enemies_draw()
   for enemy in all(enemies) do
      if enemy.hit then
         pal_all_white()
      end
      enemy:draw()
      if enemy.hit then
         pal()
      end
      if global.debug then
         pset(enemy.x,enemy.y,const.colors.red)
         print(enemy.health,enemy.x,enemy.y-8,const.colors.red)
         if enemy.hitbox ~= nil and enemy.hitbox.ttype == "rect" then
            rect(enemy.x+enemy.hitbox.x1, enemy.y+enemy.hitbox.y1,
                 enemy.x+enemy.hitbox.x2, enemy.y+enemy.hitbox.y2,
                 const.colors.blue)
         end
         if enemy.waypoints then
            if #enemy.waypoints ~= 0 then
               line(enemy.x, enemy.y,
                    enemy.waypoints[1].x, enemy.waypoints[1].y,
                    const.colors.green)
               for i=1,#enemy.waypoints do
                  if enemy.waypoints[i+1] then
                     line(enemy.waypoints[i].x, enemy.waypoints[i].y,
                          enemy.waypoints[i+1].x, enemy.waypoints[i+1].y,
                          const.colors.green)
                  end
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

function enemies_clear()
   for enemy in all(enemies) do
      enemy:dispose()
   end
end




