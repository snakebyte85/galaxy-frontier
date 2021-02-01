player={
   x=0,
   y=0,
   speed = 0.5,
   moving=false,
   
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
   if true_btnp(const.input.o) then
      create_laser_player_projectile(player.x, player.y-5)
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
      sprite_number = player.sprites.moving[flr(flr(global.step / 10)%#player.sprites.moving)+1]
   end

   spr(sprite_number, player.x-4, player.y-4)

end

