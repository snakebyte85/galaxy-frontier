projectiles={}

function create_laser_projectile(x,y, direction)

   local projectile = {
      x=x,
      y=y,
      speed=2,
      direction=direction,
      ttype="laser",
      draw=function(self) 
         local start_x = 2 * cos(self.direction+0.5)
         local start_y = 2 * sin(self.direction+0.5)
         local end_x = 2 * cos(self.direction)
         local end_y = 2 * sin(self.direction)

         line(self.x+start_x, self.y+start_y, 
              self.x+end_x, self.y+end_y, 
              const.colors.red)
      end
      
   }

   add(projectiles,projectile)

end

function create_laser_player_projectile(x,y) 

   local projectile = {
      x=x,
      y=y,
      speed=3,
      direction=const.direction.up,
      ttype="laser-player",
      draw=function(self) 
         local start_x = 2 * cos(self.direction+0.5)
         local start_y = 2 * sin(self.direction+0.5)
         local end_x = 2 * cos(self.direction)
         local end_y = 2 * sin(self.direction)

         line(self.x+start_x, self.y+start_y, 
              self.x+end_x, self.y+end_y, 
              const.colors.green)
      end
   }

   add(projectiles,projectile)

end


function projectiles_draw()

   for projectile in all(projectiles) do
      projectile:draw()
   end

end


function projectiles_update()

   local projs_to_delete = {}

   for i,projectile in ipairs(projectiles) do
      local mov_x = projectile.speed * cos(projectile.direction)
      local mov_y = projectile.speed * sin(projectile.direction)
      projectile.x = projectile.x + mov_x
      projectile.y = projectile.y + mov_y

      if projectile.x > const.screen.max_x or projectile.x < 0 or         
         projectile.y > const.screen.max_y or projectile.y < 0 then
         add(projs_to_delete, i)
      end
   end

   for i in all(projs_to_delete) do
      deli(projectiles,i)
   end
end
