player={
   x=0,
   y=0,
   speed = 30,
   direction=nil,
   lives=3,
   health=3,
   hitbox={x1=-4,y1=-4,x2=3,y2=2,ttype="rect"},
   moving=false,
   invincible=false,
   sprites={
      idle=1,
      moving={2,3}
   }
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

function player_update()
   
   if not player.dead then

      player.moving = false
      player.direction = nil
      
      if btn(const.input.left) then
         player.x = player.x - (player.speed*delta_time())
         player.moving = true
      end
      if btn(const.input.right) then
         player.x = player.x + (player.speed*delta_time())
         player.moving = true
      end
      if btn(const.input.up) then
         player.y = player.y - (player.speed*delta_time())
         player.moving = true
      end
      if btn(const.input.down) then
         player.y = player.y + (player.speed*delta_time())
         player.moving = true
      end

      if btn(const.input.up) and btn(const.input.right) then
         player.direction = const.direction.up_right
      elseif btn(const.input.up) and btn(const.input.left) then
         player.direction = const.direction.up_left
      elseif btn(const.input.down) and btn(const.input.left) then
         player.direction = const.direction.down_left
      elseif btn(const.input.down) and btn(const.input.right) then
         player.direction = const.direction.down_right
      elseif btn(const.input.right) then
         player.direction = const.direction.right
      elseif btn(const.input.up) then
         player.direction = const.direction.up
      elseif btn(const.input.left) then
         player.direction = const.direction.left
      elseif btn(const.input.down) then
         player.direction = const.direction.down
      end

      if true_btnp(const.input.o) then
         player_laser_projectile_class:new({x=player.x,y=player.y})
      end   

      if player.moving == true and
         (player.timer_ember_cooldown == nil or
          player.timer_ember_cooldown.passed) then
         local color = const.colors.yellow
         if rnd(2) > 1 then
            color=const.colors.orange
         end
         particle_class:new{
            x=player.x,
            y=player.y+3,
            direction=player.direction+0.5,
            pattern="wave",
            life_time=0.8,      
            speed=15,
            color=color
         }
         player.timer_ember_cooldown = create_timer(0.1)      
      end

      if player.x - 4 < 0 then
         player.x = 4
      end

      if player.x + 4 > const.screen.max_x then
         player.x = const.screen.max_x - 4
      end

      if player.y -4  < 0 then
         player.y = 4
      end

      if player.y + 4> const.screen.max_y then
         player.y = const.screen.max_y - 4
      end
   end

end


function player_draw()

   if not player.dead then

      local sprite_number = 0
      if not player.moving then
         sprite_number = player.sprites.idle
      else
         sprite_number = player.sprites.moving[flr(flr(time() / 0.2)%#player.sprites.moving)+1]
      end

      if not player.invincible or
         flr(flr(time() / 0.05)% 2) == 1 then
         spr(sprite_number, player.x-4, player.y-4)
      end

      if global.debug then
         pset(player.x,player.y,const.colors.red)
         rect(player.x+player.hitbox.x1, player.y+player.hitbox.y1,
              player.x+player.hitbox.x2, player.y+player.hitbox.y2,
              const.colors.blue)
         
      end
   end

end

