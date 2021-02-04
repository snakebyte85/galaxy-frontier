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

end
