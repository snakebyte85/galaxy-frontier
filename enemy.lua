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
      sprite_number=16,
      next_shot_time=0,
      init=function(self)
         enemy_class.init(self)
         self.next_shot_time = time() + random(0.5,2)
      end,
      update=function(self)
         enemy_class.update(self)
         if time() >= self.next_shot_time then
            if on_screen(self.x, self.y, -1) then
               enemy_laser_projectile_class:new({x=self.x, y=self.y+4})
            end
         self.next_shot_time = time() + random(0.5,2)
         end         
      end
})

enemy_drone_class=enemy_class:new_class({
      speed=20,
      health=10,
      score=20,
      hitbox={x1=-4,y1=-4,x2=3,y2=3,ttype="rect"},
      sprite_number=17,
      rotated=true,
      next_shot_time=0,
      init=function(self)
         enemy_class.init(self)
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
         self.next_shot_time = time() + random(0.5,2)
      end,
      update=function(self)
         enemy_class.update(self)
         if time() >= self.next_shot_time then
            if on_screen(self.x, self.y, -1) then
               if self.rotated then
                  enemy_laser_projectile_class:new({x=self.x, y=self.y-4, direction=const.direction.up })
                  enemy_laser_projectile_class:new({x=self.x-4, y=self.y, direction=const.direction.left})
                  enemy_laser_projectile_class:new({x=self.x, y=self.y+4, direction=const.direction.down})
                  enemy_laser_projectile_class:new({x=self.x+4, y=self.y, direction=const.direction.right})
               else
                  enemy_laser_projectile_class:new({x=self.x+4, y=self.y-4, direction=const.direction.up_right })
                  enemy_laser_projectile_class:new({x=self.x-4, y=self.y-4, direction=const.direction.up_left})
                  enemy_laser_projectile_class:new({x=self.x-4, y=self.y+4, direction=const.direction.down_left})
                  enemy_laser_projectile_class:new({x=self.x+4, y=self.y+4, direction=const.direction.down_right})
               end
            end
            self.next_shot_time = time() + random(0.5,2)
         end         
      end,
      dead=function(self)
         enemy_class.dead(self)
         powerup_random(self.x,self.y)
      end
})

enemy_frigate_class = enemy_class:new_class({
      speed=10,
      health=20,
      score=100,
      hitbox={x1=-10,y1=-4,x2=9,y2=2,ttype="rect"},
      sprite_number=32,
      sprite_offset={x=-12,y=-4},
      sprite_size={w=3,h=1},
      next_shot_time,
      next_generate_wp,
      init=function(self)
         enemy_class.init(self)
         self.next_shot_time = time() + random(0.5,1)
      end,
      update=function(self)
         enemy_class.update(self)

         if #self.waypoints == 0 and self.next_generate_wp == nil then
            self.next_generate_wp = time() + random(2,3)
         end
         
         if self.next_generate_wp ~= nil and 
            time() >= self.next_generate_wp then
            local x_sign = (player.x > self.x) and 1 or -1
            local y_sign = (player.y > self.y) and 1 or -1
            local next_wp = {
               x=self.x + x_sign*random(20, abs(player.x-self.x)/2),
               y=self.y + y_sign*random(20, abs(player.y-self.y)/2)
            }
            add(self.waypoints,next_wp)
            self.next_generate_wp=nil
         end

         if time() >= self.next_shot_time then
            if on_screen(self.x, self.y, -1) then
               if #self.waypoints ~= 0 then
                  enemy_laser_projectile_class:new({x=self.x-8, y=self.y+4})
                  enemy_laser_projectile_class:new({x=self.x+8, y=self.y+4})
                  self.next_shot_time = time() + random(0.5,2)
               else
                  enemy_bullet_projectile_class:new({x=self.x, 
                                                     y=self.y,
                                                     direction=atan2(player.x-self.x, player.y-self.y)+random(-0.05,0.05)
                  })
                  
                  self.next_shot_time = time() + random(0.2,0.3)
               end               
            else
               self.next_shot_time = time() + random(0.5,2)
            end
         end         
      end,
      dead=function(self)
         enemy_class.dead(self)
         powerup_random(self.x,self.y)
         powerup_coin_class:new({x=self.x-8,y=self.y})
         powerup_coin_class:new({x=self.x+8,y=self.y})
      end
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




