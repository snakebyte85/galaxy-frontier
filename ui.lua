btn_new={}
btn_press={}

function true_btnp_init()
   for i=0,5 do
      btn_new[i]=false
      btn_press[i]=false
   end
end

function true_btnp_update()
   for i=0,5 do
      if btn(i) then
         btn_new[i]=not btn_press[i]
         btn_press[i]=true
      else
         btn_new[i]=false
         btn_press[i]=false
      end
   end
end

function true_btnp(key)
   return btn_new[key]
end

function ui_init()
   true_btnp_init()
end

function ui_update()
   true_btnp_update()
end

function ui_draw()

   print("shield",2,118, const.colors.white)
   local step = flr((34 - (2*(player.max_health-1))) / player.max_health)
   local tmp = 2
   for i=1,player.health do
      rectfill(tmp,125, tmp+step,127, const.colors.green)
      tmp = tmp + step + 2
   end

   tmp = player.score
   local padding_zeroes = "0000000000"
   while tmp ~= 0 do
      tmp = flr(tmp/10)
      padding_zeroes = sub(padding_zeroes, 2)
   end

   if player.score == 0 then
      print(padding_zeroes, 45,123, const.colors.white) 
   else
      print(padding_zeroes..tostring(player.score), 45, 123, const.colors.white)
   end

   if player.second_weapon.ttype ~= nil then
      local sprite_number = 0
      if player.second_weapon.ttype == "phaser" then
         sprite_number = 8
      elseif player.second_weapon.ttype == "ring" then
         sprite_number = 9
      elseif player.second_weapon.ttype == "missile" then
         sprite_number = 10
      end
      
      spr(sprite_number, 110,120)
      print(player.second_weapon.ammo, 120,122)
   end

end
