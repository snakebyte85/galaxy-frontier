particles = {}


function create_particle_ember(x,y,direction) 

   local color = const.colors.yellow
   if flr(rnd(2)) == 1 then
      color=const.colors.orange
   end

   local ember = {
      x=x,
      y=y,
      direction=direction,
      pattern="wave",
      time_of_death=time()+1,      
      speed=0.2,
      acceleration=1,
      color=color,
      draw=function(self)         
         pset(self.x,self.y,self.color)
      end
   }
    
   add(particles,ember)
      
end


function particles_update()

   particles_to_delete={}

   for particle in all(particles) do
      
      if time() > particle.time_of_death then
         add(particles_to_delete, particle)
      else
         particle.speed = particle.speed * particle.acceleration
         if particle.pattern == nil or particle.pattern == "line" then
            local mov_x = particle.speed * cos(particle.direction)
            local mov_y = particle.speed * sin(particle.direction)
            particle.x = particle.x + mov_x
            particle.y = particle.y + mov_y         
         elseif particle.pattern == "wave" then
            
            if particle.wave_x == nil then
               particle.origin_x = particle.x
               particle.origin_y = particle.y
               particle.wave_x = particle.speed
            else
               particle.wave_x = particle.wave_x + particle.speed
            end

            local temp_x = particle.wave_x
            local temp_y = sin(temp_x*0.1)*2
            
            particle.x = ( (temp_x * cos(particle.direction) ) -
               (temp_y * sin(particle.direction) ) ) + particle.origin_x
            particle.y = ( (temp_y * cos(particle.direction) ) +
               (temp_x * sin(particle.direction) ) ) + particle.origin_y
            
         end
      end      
   end

   for particle_to_delete in all(particles_to_delete) do
      del(particles, particle_to_delete)
   end
   
end


function particles_draw()
   for particle in all(particles) do
      particle:draw()
   end
end
