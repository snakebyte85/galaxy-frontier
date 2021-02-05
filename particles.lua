particles = {}

particle_class = entity_class:new_class {
      init=function(self)       
         entity_class.init(self)
         add(particles,self)
      end,      
      dispose=function(self)
         entity_class.dispose(self)
         del(particles,self)
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
         speed=random(20,40),
         acceleration=-random(20,40),
         color=const.colors.dark_blue
      }

   end
end

function particles_clear()
   for particle in all(particles) do
      particle:dispose()
   end
end
   
