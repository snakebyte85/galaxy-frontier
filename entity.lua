entities={}

entities_draw_order = {}

for i=1,20 do
   add(entities_draw_order,{})
end

entity_class = {
   x=0,
   y=0,
   z=10,
   direction=nil,
   speed=1,
   acceleration=0,
   pattern="line",
   waypoints={},
   time_of_birth=nil,
   life_time=nil,
   time_of_death=nil,
   hitbox={},
   color=const.colors.white,
   sprite_number=nil,
   sprite_size={w=1,h=1},
   sprite_offset={x=-4,y=-4},
   entity_timers={},
   init=function(self)
      self.time_of_birth=time()
      if self.life_time then
         self.time_of_death=time() + self.life_time
      end
   end,   
   dispose=function(self)
      for entity_timer in all(entity_timers) do
         stop_timer(entity_timer)
      end
      del(entities,self)
      del(entities_draw_order[self.z+1], self)
   end,
   update=function(self)
      update_entity(self)
   end,
   draw=function(self)
      draw_entity(self)
   end,
   new=function(self,o)
      self.__index = self
      o=setmetatable(o or {}, self)
      o:init()
      add(entities,o)
      add(entities_draw_order[o.z+1],o)
      return o
   end,
   new_class=function(self,o)
      self.__index = self
      o=setmetatable(o or {}, self)
      return o
   end
}

function update_entity(entity)

   entity.speed = entity.speed + (entity.acceleration*delta_time())
   if entity.speed < 0 then
      entity.speed = 0
   end

   if entity.pattern == nil or entity.pattern == "line" then
      local mov_x = (entity.speed*delta_time()) * cos(entity.direction)
      local mov_y = (entity.speed*delta_time()) * sin(entity.direction)
      entity.x = entity.x + mov_x
      entity.y = entity.y + mov_y         
   elseif entity.pattern == "wave" then
      
      if entity.wave_x == nil then
         entity.origin_x = entity.x
         entity.origin_y = entity.y
         entity.wave_x = random(0,10)
      else
         entity.wave_x = entity.wave_x + (entity.speed*delta_time())
      end

      local temp_x = entity.wave_x
      local temp_y = sin(temp_x*0.1)*2
      
      entity.x = ( (temp_x * cos(entity.direction) ) - (temp_y * sin(entity.direction) ) ) + entity.origin_x
      entity.y = ( (temp_y * cos(entity.direction) ) + (temp_x * sin(entity.direction) ) ) + entity.origin_y

   elseif entity.pattern == "waypoints" then

      if entity.waypoints ~= nil and #entity.waypoints ~= 0 then

         local next_wp_x = entity.waypoints[1].x
         local next_wp_y = entity.waypoints[1].y
         local next_wp_bc = entity.waypoints[1].bc

         local mov_x = 0
         local mov_y = 0

         if abs(entity.x - next_wp_x) <= const.delta and
            abs(entity.y - next_wp_y) <= const.delta then
            deli(entity.waypoints,1)
         else
            if next_wp_bc == nil then              
               entity.direction = atan2(next_wp_x-entity.x, next_wp_y-entity.y)
               local speed_to_apply = sqrt((next_wp_x-entity.x)^2 + (next_wp_y-entity.y)^2)
               if (entity.speed*delta_time()) < speed_to_apply then
                  speed_to_apply = entity.speed*delta_time()
               end
               mov_x = speed_to_apply * cos(entity.direction)
               mov_y = speed_to_apply * sin(entity.direction)
            else 
               local control_point_x = next_wp_bc.x
               local control_point_y = next_wp_bc.y
               local number_of_points = next_wp_bc.num
               local waypoints_bc = calculate_waypoints_bc(entity.x,entity.y,
                                                           next_wp_x,next_wp_y,
                                                           control_point_x, control_point_y,
                                                           number_of_points)
               deli(entity.waypoints,1)
               for i=1,#waypoints_bc do
                  add(entity.waypoints,waypoints_bc[i], i)
               end
            end
         end
         entity.x = entity.x + mov_x
         entity.y = entity.y + mov_y   
      end
   end
      
   if (entity.time_of_death ~=nil and time() > entity.time_of_death) or
      not on_screen(entity.x,entity.y,10) then   
      entity:dispose()
   end
      
end

function draw_entity(entity) 

   if entity.sprite_number ~= nil then
      spr(entity.sprite_number, 
          entity.x+entity.sprite_offset.x, 
          entity.y+entity.sprite_offset.y,
          entity.sprite_size.w,
          entity.sprite_size.h)
   elseif entity.hitbox.ttype=="line" then         
      local start_x = (entity.hitbox.length/2) * cos(entity.direction+0.5)
      local start_y = (entity.hitbox.length/2) * sin(entity.direction+0.5)
      local end_x = (entity.hitbox.length/2) * cos(entity.direction)
      local end_y = (entity.hitbox.length/2) * sin(entity.direction)
      
      line(entity.x+start_x, entity.y+start_y, 
           entity.x+end_x, entity.y+end_y, 
           entity.color)
   else
      pset(entity.x,entity.y,entity.color)
   end

   if global.debug then            
      if entity.hitbox ~= nil and entity.hitbox.ttype == "rect" then
         rect(entity.x+entity.hitbox.x1, entity.y+entity.hitbox.y1,
              entity.x+entity.hitbox.x2, entity.y+entity.hitbox.y2,
              const.colors.blue)
      end
      if entity.waypoints then
         if #entity.waypoints ~= 0 then
            line(entity.x, entity.y,
                 entity.waypoints[1].x, entity.waypoints[1].y,
                 const.colors.green)
            for i=1,#entity.waypoints do
               if entity.waypoints[i+1] then
                  line(entity.waypoints[i].x, entity.waypoints[i].y,
                       entity.waypoints[i+1].x, entity.waypoints[i+1].y,
                       const.colors.green)
               end
            end
         end
      end
   end
end

function entities_update()
   for entity in all(entities) do      
      entity:update()
   end

   player_check_collision()
   player_projectiles_check_collision()

end

function entities_draw()
   for i=1,#entities_draw_order do
      for entity in all(entities_draw_order[i]) do
         entity:draw()
      end
   end
end
