powerups = {} 

player=entity_class:new{
   z=19,
   lives=3,
   health=3,
   max_health=3,
   powerup_speed=0,
   laser_count=1,
   second_weapon={
      ttype=nil,
      ammo=0
   },
   hitbox={x1=-4,y1=-4,x2=3,y2=2,ttype="rect"},
   moving=false,
   invincible=false,
   dead=true,
   score=0,
   sprite_number=1,
   sprites_moving={2,3},
   reset=function(self)
      self.health=3
      self.max_health=3
      self.dead=false
      self.x=60
      self.y=100
      self.powerup_speed=0         
      self.laser_count=1
      self.second_weapon.ttype=nil
      self.second_weapon.ammo=0
   end,
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
            self.speed = 40
         else
            sprite_number = 1
         end
         
         if true_btnp(const.input.o) then
            if self.laser_count == 1 then
               player_laser_projectile_class:new({x=self.x,y=self.y-2})
            elseif self.laser_count == 2 then
               player_laser_projectile_class:new({x=self.x-2,y=self.y-2})
               player_laser_projectile_class:new({x=self.x+2,y=self.y-2})
            elseif self.laser_count == 3 then
               player_laser_projectile_class:new({x=self.x-2,y=self.y-2,direction=0.30})
               player_laser_projectile_class:new({x=self.x,y=self.y-2})
               player_laser_projectile_class:new({x=self.x+2,y=self.y-2,direction=0.20})
            end
         end   

         if true_btnp(const.input.x) and 
            (self.second_weapon.ttype ~= nil and self.second_weapon.ammo > 0) and
            (self.timer_second_weapon_cooldown == nil or 
             self.timer_second_weapon_cooldown.passed) then
            
            if self.second_weapon.ttype == "missile" then
               player_missile_projectile_class:new({x=self.x,y=self.y-2})
            elseif self.second_weapon.ttype == "phaser" then
               player_phaser_projectile_class:new({x=self.x,y=self.y-2})
            elseif self.second_weapon.ttype == "ring" then
               for dir=0,1,0.05 do                  
                  player_laser_projectile_class:new({x=self.x,
                                                     y=self.y,
                                                     direction=dir,
                                                     damage=3,
                                                     color=const.colors.yellow})
               end
            end
            self.second_weapon.ammo = self.second_weapon.ammo - 1
            if self.second_weapon.ammo == 0 then
               self.second_weapon.ttype = nil
            end
            self.timer_second_weapon_cooldown = create_timer(0.5)
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

         if self.speed ~= 0 then
            self.speed = self.speed + self.powerup_speed
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
         for enemy_projectile in all(group_projectiles.enemy) do      
            if entities_collision_check(player,enemy_projectile) then
               player_hit()
               enemy_projectile:dispose()
               break
            end   
         end
         for neutral_projectile in all(group_projectiles.neutral) do      
            if entities_collision_check(player,neutral_projectile) then
               player_hit()
               neutral_projectile:dispose()
               break
            end   
         end
      end
   end
      
   for powerup in all(powerups) do
      if entities_collision_check(player,powerup) then
         powerup:picked_up_by_player()
         powerup:dispose()
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

powerup_class=entity_class:new_class{
   score=10,
   pattern="line",
   direction=const.direction.down,
   speed=20,
   hitbox={x1=-4,y1=-4,x2=3,y2=3,ttype="rect"},
   init=function(self)
      entity_class.init(self)
      add(powerups,self)
   end,
   picked_up_by_player=function(self) 
      player.score = player.score + self.score
   end,
   dispose=function(self)
      entity_class.dispose(self)
      del(powerups,self)
   end
}

powerup_shield_class=powerup_class:new_class{
   sprite_number=4,
   picked_up_by_player=function(self)
      powerup_class.picked_up_by_player(self)
      if player.health < player.max_health then
         player.health = player.health + 1
      end
   end
}

powerup_shield_plus_class=powerup_class:new_class{
   sprite_number=5,
   picked_up_by_player=function(self)
      powerup_class.picked_up_by_player(self)
      if player.max_health < 5  then
         player.max_health = player.max_health + 1
      end
   end
}

powerup_life_class=powerup_class:new_class{
   sprite_number=6,
   picked_up_by_player=function(self)
      powerup_class.picked_up_by_player(self)
      player.lives = player.lives+1
   end
}

powerup_speed_class=powerup_class:new_class{
   sprite_number=7,
   picked_up_by_player=function(self)
      powerup_class.picked_up_by_player(self)
      player.powerup_speed = 20
   end
}

powerup_phaser_class=powerup_class:new_class{
   sprite_number=8,
   picked_up_by_player=function(self)
      powerup_class.picked_up_by_player(self)
      if player.second_weapon.ttype=="phaser" then
         player.second_weapon.ammo = player.second_weapon.ammo + 5
      else
         player.second_weapon.ttype="phaser"
         player.second_weapon.ammo=5
      end
   end
}

powerup_ring_class=powerup_class:new_class{
   sprite_number=9,
   picked_up_by_player=function(self)
      powerup_class.picked_up_by_player(self)
      if player.second_weapon.ttype=="ring" then
         player.second_weapon.ammo = player.second_weapon.ammo + 5
      else
         player.second_weapon.ttype="ring"
         player.second_weapon.ammo=5
      end
   end
}

powerup_missile_class=powerup_class:new_class{
   sprite_number=10,
   picked_up_by_player=function(self)
      powerup_class.picked_up_by_player(self)
      if player.second_weapon.ttype=="missile" then
         player.second_weapon.ammo = player.second_weapon.ammo + 5
      else
         player.second_weapon.ttype="missile"
         player.second_weapon.ammo=5
      end
   end
}

powerup_multi_laser_class=powerup_class:new_class{
   sprite_number=11,
   picked_up_by_player=function(self)
      powerup_class.picked_up_by_player(self)
      if player.laser_count ~= 3 then
         player.laser_count = player.laser_count + 1
      end
   end,
   draw=function(self)
      if player.laser_count == 1 then
         self.sprite_number=11
      else
         self.sprite_number=12
      end
      powerup_class.draw(self)
   end
}

powerup_coin_class=powerup_class:new_class{
   score=50,
   draw=function(self)
      self.sprite_number = flr(flr(time() / 0.2)%2)+13
      powerup_class.draw(self)
   end
}

function powerup_random(x,y) 

   local number = flr(rnd(6))

   if number == 0 then
      powerup_shield_class:new({x=x,y=y})
   elseif number == 1 then
      powerup_speed_class:new({x=x,y=y})
   elseif number == 2 then
      powerup_missile_class:new({x=x,y=y})
   elseif number == 3 then
      powerup_phaser_class:new({x=x,y=y})
   elseif number == 4 then
      powerup_multi_laser_class:new({x=x,y=y})
   elseif number == 5 then
      powerup_ring_class:new({x=x,y=y})
   end

end

function powerups_clear()
   for powerup in all(powerups) do
      powerup:dispose()
   end
end
