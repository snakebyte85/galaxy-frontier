projectiles={}
group_projectiles={
   player={},
   enemy={},
   neutral={}
}

projectile_class={
   x=0,
   y=0,
   speed=200,
   direction=nil,
   hitbox={},
   group="enemy",
   damage=1,
   ttype=nil,
   sprite_number=nil,
   sprite_offset={x=0,y=0},
   sprite_size={w=1,h=1},
   color=const.colors.red,
   init=function(self)
   end,
   dispose=function(self)      
      del(projectiles,self)
      del(group_projectiles[self.group],self)
   end,
   update=function(self)
      local mov_x = (self.speed*delta_time()) * cos(self.direction)
      local mov_y = (self.speed*delta_time()) * sin(self.direction)
      self.x = self.x + mov_x
      self.y = self.y + mov_y
   end,
   draw=function(self) 
      if self.sprite_number == nil and
         self.hitbox.ttype=="line" then
         
         local start_x = (self.hitbox.length/2) * cos(self.direction+0.5)
         local start_y = (self.hitbox.length/2) * sin(self.direction+0.5)
         local end_x = (self.hitbox.length/2) * cos(self.direction)
         local end_y = (self.hitbox.length/2) * sin(self.direction)

         line(self.x+start_x, self.y+start_y, 
              self.x+end_x, self.y+end_y, 
              self.color)
      else 
         spr(self.sprite_number, 
             self.x+self.sprite_offset.x, 
             self.y+self.sprite_offset.y,
             self.sprite_size.w,
             self.sprite_size.h)
      end
   end,
   new=function(self,o)
      self.__index = self
      o=setmetatable(o or {}, self)
      o:init()
      add(projectiles,o)
      add(group_projectiles[o.group], o)
      return o
   end,
   new_class=function(self,o)
      self.__index = self
      o=setmetatable(o or {}, self)
      return o
   end
}

enemy_laser_projectile_class = projectile_class:new_class({
      hitbox={length=4,ttype="line"},
      ttype="enemy-laser"      
})

player_laser_projectile_class = projectile_class:new_class({
      hitbox={length=4,ttype="line"},
      ttype="player-laser",
      group="player",
      direction=const.direction.up,
      color=const.colors.green
})

function player_projectiles_check_collision()

   for player_projectile in all(group_projectiles.player) do
      for enemy in all(enemies) do
         if entities_collision_check(player_projectile, enemy) then
            enemy:on_hit(player_projectile.damage)
            player_projectile:dispose()            
            break
         end
      end
   end

end

function projectiles_draw()
   for projectile in all(projectiles) do
      projectile:draw()
   end
end


function projectiles_update()

   for projectile in all(projectiles) do      
      projectile:update()
      if projectile.x > const.screen.max_x or projectile.x < 0 or         
         projectile.y > const.screen.max_y or projectile.y < 0 then
         projectile:dispose()
      end
   end
end
