projectiles={}
group_projectiles={
   player={},
   enemy={},
   neutral={}
}

projectile_class=entity_class:new_class{
   speed=200,
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
})

player_laser_projectile_class = projectile_class:new_class({
      hitbox={length=4,ttype="line"},
      group="player",
      direction=const.direction.up,
      color=const.colors.green
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
   for enemy in all(projectiles) do
      projectile:dispose()
   end
end
