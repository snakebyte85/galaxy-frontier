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

function lv(v1,v2,t)
    return (1-t)*v1+t*v2
end

--Quadratic Bezier Curve Vector
function qbcvector(v1,v2,v3,t) 
    return  lv(lv(v1,v3,t), lv(v3,v2,t),t)
end

function calculate_waypoints_bc(x1,y1,x2,y2,x3,y3,number_of_points)

   local waypoints_bc = {}

   for i=1,number_of_points do
      local t = i/number_of_points
      local waypoint_bc = { x=qbcvector(x1,x2,x3,t), y=qbcvector(y1,y2,y3,t) }
      add(waypoints_bc, waypoint_bc)
   end

   return waypoints_bc
end

function tostring(any)
    if type(any)=="function" then 
        return "function" 
    end
    if any==nil then 
        return "nil" 
    end
    if type(any)=="string" then
        return any
    end
    if type(any)=="boolean" then
        if any then return "true" end
        return "false"
    end
    if type(any)=="table" then
        local str = "{ "
        for k,v in pairs(any) do
            str=str..tostring(k).."->"..tostring(v).." "
        end
        return str.."}"
    end
    if type(any)=="number" then
        return ""..any
    end
    return "unkown" -- should never show
end

function log(str)
   if global.log == true then
      printh(tostring(str), "galaxy.log")
   end
end
