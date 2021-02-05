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
   if player.health >= 1 then
      rectfill(2,125, 12,127, const.colors.green)
   end

   if player.health >= 2 then
      rectfill(14,125, 24,127, const.colors.green)
   end

   if player.health >= 3 then
      rectfill(26,125, 36,127, const.colors.green)
   end

   local tmp = player.score
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

end
