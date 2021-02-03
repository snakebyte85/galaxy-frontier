particles = {}

particle_class = {
      x=0,
      y=0,
      direction=nil,
      pattern="line",
      time_of_birth=nil,
      life_time=nil,
      time_of_death=nil,
      speed=2,
      acceleration=0,
      color=const.colors.white,
      sprite_number=nil,
      sprite_offset={x=0,y=0},
      sprite_size={w=1,h=1},
      init=function(self)
         self.time_of_birth=time()
         if self.life_time then
            self.time_of_death=time() + self.life_time
         end
      end,
      dispose=function(self)
         del(particles,self)
      end,
      update=function(self)
         self.speed = self.speed + self.acceleration
         if self.speed < 0 then
            self.speed = 0
         end

         if self.pattern == nil or self.pattern == "line" then
            local mov_x = self.speed * cos(self.direction)
            local mov_y = self.speed * sin(self.direction)
            self.x = self.x + mov_x
            self.y = self.y + mov_y         
         elseif self.pattern == "wave" then
            
            if self.wave_x == nil then
               self.origin_x = self.x
               self.origin_y = self.y
               self.wave_x = random(0,10)
            else
               self.wave_x = self.wave_x + self.speed
            end

            local temp_x = self.wave_x
            local temp_y = sin(temp_x*0.1)*2
            
            self.x = ( (temp_x * cos(self.direction) ) -
               (temp_y * sin(self.direction) ) ) + self.origin_x
            self.y = ( (temp_y * cos(self.direction) ) +
               (temp_x * sin(self.direction) ) ) + self.origin_y
            
         end
      end,
      draw=function(self)         
         if self.sprite_number ~= nil then
            spr(self.sprite_number, 
             self.x+self.sprite_offset.x, 
             self.y+self.sprite_offset.y,
             self.sprite_size.w,
             self.sprite_size.h)
         else 
            pset(self.x,self.y,self.color)
         end
      end,
      new=function(self,o)
         self.__index = self
         o=setmetatable(o or {}, self)
         add(particles,o)
         o:init()
         return o
      end,
      new_class=function(self,o)
         self.__index = self
         o=setmetatable(o or {}, self)
         return o
      end
}

function create_particle_explosion(x,y)

   for i=1,20 do
      local direction = random((i-1)/20, i/20)
      particle_class:new{
         x=x,
         y=y,
         direction=direction,
         pattern="line",
         life_time=0.8,      
         speed=random(0.4,0.8),
         acceleration=-random(0.01,0.02),
         color=const.colors.dark_blue
      }

   end
end

function particles_update()

   for particle in all(particles) do
      
      if (particle.time_of_death ~=nil and time() > particle.time_of_death) or
         (particle.x > const.screen.max_x + 32 or particle.x < -32 or
          particle.y > const.screen.max_y + 32 or particle.y < -32) then
         particle:dispose()
      else
         particle:update()
      end      
   end
   
end


function particles_draw()
   for particle in all(particles) do
      particle:draw()
   end
end
