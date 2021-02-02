projectiles={}

player_projectiles={}
enemy_projectiles={}

function create_laser_projectile(x,y, direction)

   local projectile = {
      x=x,
      y=y,
      speed=2,
      direction=direction,
      hitbox={length=4,ttype="line"},
      ttype="laser",
      update=function(self)
         update_regular_projectile(self)
      end,
      draw=function(self) 
         local start_x = (self.hitbox.length/2) * cos(self.direction+0.5)
         local start_y = (self.hitbox.length/2) * sin(self.direction+0.5)
         local end_x = (self.hitbox.length/2) * cos(self.direction)
         local end_y = (self.hitbox.length/2) * sin(self.direction)

         line(self.x+start_x, self.y+start_y, 
              self.x+end_x, self.y+end_y, 
              const.colors.red)
      end
      
   }

   add(projectiles,projectile)
   add(enemy_projectiles, projectile)

end

function create_bomb_projectile(x,y)

   local projectile = {
      x=x,
      y=y,
      speed=0.5,
      direction=direction,
      hitbox={x1=-2,y1=-1,x2=1,y2=2,ttype="rect"},
      ttype="bomb",
      update=function(self)
      
      end,
      draw=function(self) 
         local sprite_number=flr(flr(time() / 0.2)%2)+20
         spr(sprite_number, self.x-4, self.y-4)
      end
      
   }

   add(projectiles,projectile)
   add(enemy_projectiles, projectile)
end

function create_laser_player_projectile(x,y) 

   local projectile = {
      x=x,
      y=y,
      speed=3,
      direction=const.direction.up,
      damage=2,
      hitbox={length=4,ttype="line"},
      ttype="laser-player",
      update=function(self)
         update_regular_projectile(self)
      end,
      draw=function(self) 
         local start_x = (self.hitbox.length/2) * cos(self.direction+0.5)
         local start_y = (self.hitbox.length/2) * sin(self.direction+0.5)
         local end_x = (self.hitbox.length/2) * cos(self.direction)
         local end_y = (self.hitbox.length/2) * sin(self.direction)

         line(self.x+start_x, self.y+start_y, 
              self.x+end_x, self.y+end_y, 
              const.colors.green)
      end
   }

   add(projectiles,projectile)
   add(player_projectiles, projectile)

end

function update_regular_projectile(projectile)
   local mov_x = projectile.speed * cos(projectile.direction)
   local mov_y = projectile.speed * sin(projectile.direction)
   projectile.x = projectile.x + mov_x
   projectile.y = projectile.y + mov_y
end

function player_projectiles_check_collision()

   for player_projectile in all(player_projectiles) do
      for enemy in all(enemies) do
         if entities_collision_check(player_projectile, enemy) then
            enemy_hit(enemy, player_projectile.damage)
            del(projectiles, player_projectile)
            del(player_projectiles, player_projectile)
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

   local projs_to_delete = {}

   for projectile in all(projectiles) do      
      projectile:update()
      if projectile.x > const.screen.max_x or projectile.x < 0 or         
         projectile.y > const.screen.max_y or projectile.y < 0 then
         add(projs_to_delete, projectile)
      end
   end

   for projectile_to_delete in all(projs_to_delete) do
      del(player_projectiles,projectile_to_delete)
      del(enemy_projectiles,projectile_to_delete)
      del(projectiles,projectile_to_delete)
   end
end
