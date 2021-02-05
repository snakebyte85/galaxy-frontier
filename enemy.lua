enemies = {}

enemy_class = entity_class:new_class{
   health=5,
   hit=false,
   score=10,
   pattern="waypoints",
   init=function(self)
      entity_class.init(self)
      add(enemies,self)
   end,
   on_hit=function(self,damage) 
      self.health = self.health - damage

      if self.health <= 0 then         
         self:dead()         
      else       
         self.hit = true
         local enemy_timer = create_timer(0.1, 
                      function(this_enemy) 
                         this_enemy.hit = false
                      end,
                      {self})
         add(self.enemy_timers,enemy_timer)         
      end
   end,
   dead=function(self)      
      create_particle_explosion(self.x,self.y)
      player.score = player.score + self.score
      self:dispose()
   end,
   dispose=function(self)
      entity_class.dispose(self)
      del(enemies,self)
   end,
   draw=function(self)
      if self.hit then
         pal_all_white()
      end
      entity_class.draw(self)
      if self.hit then
         pal()
      end
      if global.debug then         
         print(self.health,self.x-1,self.y-8,const.colors.red)
      end
   end
}

enemy_raider_class = enemy_class:new_class({
      speed=30,
      health=5,
      hitbox={x1=-4,y1=-4,x2=3,y2=2,ttype="rect"},
      sprite_number=16
})

enemy_drone_class= enemy_class:new_class({
      speed=20,
      health=10,
      score=20,
      hitbox={x1=-4,y1=-4,x2=3,y2=3,ttype="rect"},
      sprite_number=17,
      rotated=false,
      init=function(self)
         local timer = create_timer(2,
                                    function(this) 
                                       this.rotated = not this.rotated                                 
                                       if this.rotated then
                                          this.sprite_number = 17
                                       else
                                          this.sprite_number = 18
                                       end
                                    end,
                                    {self},
                                    true)

         add(self.entity_timers,timer)
      end
})

enemy_frigate_class = enemy_class:new_class({
      speed=10,
      health=20,
      score=100,
      hitbox={x1=-10,y1=-4,x2=9,y2=2,ttype="rect"},
      sprite_number=32,
      sprite_offset={x=-12,y=-4},
      sprite_size={w=3,h=1}
})


enemy_bomber_class=enemy_class:new_class({
      x=x,
      y=y,
      waypoints=waypoints,
      speed=20,
      health=9,
      score=20,
      hitbox={x1=-4,y1=-4,x2=3,y2=3,ttype="rect"},
      sprite_number=19
})

function enemies_clear()
   for enemy in all(enemies) do
      enemy:dispose()
   end
end




