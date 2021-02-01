player={
   x=0,
   y=0,
   speed = 0.5,
   moving=false,
   direction=nil,
   hitbox={x1=-4,y1=-4,x2=3,y2=2},
   sprites={
      idle=1,
      moving={2,3}
   }
}

function player_init()

   player.x = 30
   player.y = 30
   player.moving = false

end

function player_update()

   player.moving = false
   player.direction = nil
   
   if btn(const.input.left) then
      player.x = player.x - player.speed
      player.moving = true
   end
   if btn(const.input.right) then
      player.x = player.x + player.speed
      player.moving = true
   end
   if btn(const.input.up) then
      player.y = player.y - player.speed
      player.moving = true
   end
   if btn(const.input.down) then
      player.y = player.y + player.speed
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
      create_laser_player_projectile(player.x, player.y-5)
   end   

   if player.moving == true and
      (player.timer_ember_cooldown == nil or
       player.timer_ember_cooldown.passed) then
          create_particle_ember(player.x, player.y+3,player.direction+0.5)
          player.timer_ember_cooldown = create_timer(0.5)      
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


function player_draw()

   sprite_number = 0
   if not player.moving then
      sprite_number = player.sprites.idle
   else
      sprite_number = player.sprites.moving[flr(flr(time() / 0.2)%#player.sprites.moving)+1]
   end

   spr(sprite_number, player.x-4, player.y-4)

   if global.debug then
      pset(player.x,player.y,const.colors.red)
      rect(player.x+player.hitbox.x1, player.y+player.hitbox.y1,
           player.x+player.hitbox.x2, player.y+player.hitbox.y2,
           const.colors.blue)
   end

end

