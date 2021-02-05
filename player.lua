player=entity_class:new{
   z=19,
   lives=3,
   health=3,
   hitbox={x1=-4,y1=-4,x2=3,y2=2,ttype="rect"},
   moving=false,
   invincible=false,
   dead=true,
   score=0,
   sprite_number=1,
   sprites_moving={2,3},
   dispose=function(self)
      -- no
   end,
   update=function(self) 
      if not self.dead then
         self.moving = false
         self.speed=0
         self.direction = nil      
         if btn(const.input.up) and btn(const.input.right) then
            self.direction = const.direction.up_right
         elseif btn(const.input.up) and btn(const.input.left) then
            self.direction = const.direction.up_left
         elseif btn(const.input.down) and btn(const.input.left) then
            self.direction = const.direction.down_left
         elseif btn(const.input.down) and btn(const.input.right) then
            self.direction = const.direction.down_right
         elseif btn(const.input.right) then
            self.direction = const.direction.right
         elseif btn(const.input.up) then
            self.direction = const.direction.up
         elseif btn(const.input.left) then
            self.direction = const.direction.left
         elseif btn(const.input.down) then
            self.direction = const.direction.down
         end   
         
         if self.direction ~= nil then
            self.moving = true
            self.speed = 30
         else
            sprite_number = 1
         end
         
         if true_btnp(const.input.o) then
            player_laser_projectile_class:new({x=self.x,y=self.y-2})
         end   

         if self.moving == true and
            (self.timer_ember_cooldown == nil or
             self.timer_ember_cooldown.passed) then
            local color = const.colors.yellow
            if rnd(2) > 1 then
               color=const.colors.orange
            end
            particle_class:new{
               x=self.x,
               y=self.y+3,
               direction=self.direction+0.5,
               pattern="wave",
               life_time=0.8,      
               speed=15,
               color=color
            }
            self.timer_ember_cooldown = create_timer(0.1)      
         end

         entity_class.update(self)

         if self.x - 4 < 0 then
            self.x = 4
         end

         if self.x + 4 > const.screen.max_x then
            self.x = const.screen.max_x - 4
         end

         if self.y -4  < 0 then
            self.y = 4
         end

         if self.y + 4> const.screen.max_y then
            self.y = const.screen.max_y - 4
         end
      end
   end,
   draw=function(self)
      if not self.dead then            
         if not self.moving then
            self.sprite_number = 1
         else
            self.sprite_number = self.sprites_moving[flr(flr(time() / 0.2)%#self.sprites_moving)+1]
         end

         if not self.invincible or
            flr(flr(time() / 0.05)% 2) == 1 then
            entity_class.draw(self)
         end
      end
   end
}


function player_check_collision()

   if not player.invincible then

      local hit_by_enemy = false
      for enemy in all(enemies) do      
         if entities_collision_check(player,enemy) then
            player_hit()
            hit_by_enemy = true
            break
         end   
      end

      if not hit_by_enemy then
         for enemy_projectile in all(enemy_projectiles) do      
            if entities_collision_check(player,enemy_projectile) then
               player_hit()
               del(projectiles, enemy_projectile)
               del(enemy_projectiles, enemy_projectile)
               break
            end   
         end
      end
   end
end

function player_hit()
   player.health = player.health - 1
   if player.health == 0 then
      create_particle_explosion(player.x,player.y)
      player.lives = player.lives - 1
      player.dead = true
      create_timer(3, game_player_dead)
   end
   player.invincible = true
   create_timer(3,
                function()
                   player.invincible = false
                end)
end
