

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

function translate_hitbox(hitbox,x,y,direction)
   local translated_hitbox = { }
   if hitbox.ttype == "rect" then
      
      translated_hitbox.x1 = x+hitbox.x1
      translated_hitbox.y1 = y+hitbox.y1
      translated_hitbox.x2 = x+hitbox.x2
      translated_hitbox.y2 = y+hitbox.y2
      translated_hitbox.ttype = "rect"

   elseif hitbox.ttype == "line" then
      local start_x = (hitbox.length/2) * cos(direction+0.5)
      local start_y = (hitbox.length/2) * sin(direction+0.5)
      local end_x = (hitbox.length/2) * cos(direction)
      local end_y = (hitbox.length/2) * sin(direction)

      translated_hitbox.x1 = x+start_x
      translated_hitbox.y1 = y+start_y
      translated_hitbox.x2 = x+end_x
      translated_hitbox.y2 = y+end_y
      translated_hitbox.ttype = "line"

   end

   return translated_hitbox

end

function entities_collision_check(entity1, entity2)

   local translated_hitbox1=translate_hitbox(entity1.hitbox, entity1.x, entity1.y, entity1.direction)
   local translated_hitbox2=translate_hitbox(entity2.hitbox, entity2.x, entity2.y,entity2.direction)

   if translated_hitbox1.ttype == "rect" and 
      translated_hitbox2.ttype == "rect" then
      return rect_hitboxes_collision_check(translated_hitbox1,translated_hitbox2)
   elseif translated_hitbox1.ttype == "rect" 
      and translated_hitbox2.ttype == "line" then
      return rect_line_hitboxes_collision_check(translated_hitbox1,translated_hitbox2)
   elseif translated_hitbox1.ttype == "line" 
      and translated_hitbox2.ttype == "rect" then
      return rect_line_hitboxes_collision_check(translated_hitbox2,translated_hitbox1)
   end
end

function rect_hitboxes_collision_check(hitbox1,hitbox2)
   local c1 = hitbox1.x1 <= hitbox2.x2
   local c2 = hitbox1.x2 >= hitbox2.x1
   local c3 = hitbox1.y1 <= hitbox2.y2
   local c4 = hitbox1.y2 >= hitbox2.y1
   return c1 and c2 and c3 and c4
end

function rect_line_hitboxes_collision_check(rect_hitbox, line_hitbox)
   
   return rect_point_hitboxes_collision_check(line_hitbox.x1, line_hitbox.y1,
                                              rect_hitbox) or
      rect_point_hitboxes_collision_check(line_hitbox.x2, line_hitbox.y2,
                                              rect_hitbox)
      
end

function rect_point_hitboxes_collision_check(x,y,hitbox) 
   return x >= hitbox.x1 and x <= hitbox.x2 and
      y >= hitbox.y1 and y <= hitbox.y2
end

function pal_all_white()
   for color_name,color_value in pairs(const.colors) do
      pal(color_value, const.colors.white)
   end
end

function random(min, max)
   return min + rnd(max-min)
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
