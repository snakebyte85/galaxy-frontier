projectiles={}
group_projectiles={
   player={},
   enemy={},
   neutral={}
}

projectile_class=entity_class:new_class{
   speed=100,
   group="enemy",
   damage=1,
   init=function(self)
      entity_class.init(self)
      add(projectiles,self)
      add(group_projectiles[self.group], self)
   end,
   dispose=function(self)      
      entity_class.dispose(self)
      del(projectiles,self)
      del(group_projectiles[self.group],self)
   end
}

enemy_laser_projectile_class = projectile_class:new_class({
      hitbox={length=4,ttype="line"},
      direction=const.direction.down,
      color=const.colors.red
})

enemy_bullet_projectile_class = projectile_class:new_class({
      hitbox={x1=-2,y1=-1,x2=1,y2=2,ttype="rect"},
      sprite_number=28,
      sprite_offset={x=-2,y=-1},
      speed=20
})

player_laser_projectile_class = projectile_class:new_class({
      speed=200,
      hitbox={length=4,ttype="line"},
      group="player",
      direction=const.direction.up,
      color=const.colors.green
})

player_missile_projectile_class = projectile_class:new_class({
      speed=20,
      hitbox={x1=-1,y1=-2,x2=1,y2=2,ttype="rect"},
      group="player",
      direction=const.direction.up,
      sprite_number=26,
      sprite_offset={x=-1,y=-2},
      damage=5,
      acceleration=100,
      pattern="waypoints",
      init=function(self)
         projectile_class.init(self)
         local sign = (self.direction==const.direction.up) and -1 or 1
         local target_x = self.x
         local target_y = self.y + (sign*100)
         add(self.waypoints, {x=target_x, y=target_y, 
                              bc={x=target_x+50, y=self.y + (sign*50), num=10}
                             })
      end,
      draw=function(self)
         self.sprite_number = flr(flr(time() / 0.2)%2)+26
         projectile_class.draw(self)
      end
})

player_phaser_projectile_class = projectile_class:new_class({
      speed=100,
      hitbox={x1=-2,y1=-3,x2=2,y2=3,ttype="rect"},
      group="player",
      direction=const.direction.up,
      sprite_number=29,
      sprite_offset={x=-2,y=-3},
      damage=5
})

function player_projectiles_check_collision()

   for player_projectile in all(group_projectiles.player) do
      for enemy in all(enemies) do
         if entities_collision_check(player_projectile, enemy) then
            enemy:on_hit(player_projectile.damage)
            player_projectile:dispose()            
            break
         end
      end
   end
end

function projectiles_clear()
   for projectile in all(projectiles) do
      projectile:dispose()
   end
end
