function game_init()
   ui_init()
   space_init()
   player.x = 30
   player.y = 80
   player.moving = false
   enemy_raider_class:new({x=63,y=-10,
                     waypoints={
                          {x=63,y=10},
                          {x=118,y=63, bc={x=128,y=0,num=10} },
                          {x=63,y=118, bc={x=128,y=128,num=10} },
                          {x=10,y=63,  bc={x=0,y=128,num=10} },
                          {x=63,y=10,  bc={x=0,y=0,num=10} }
                          }
   })
   enemy_raider_class:new({x=63,y=63})                          
   enemy_drone_class:new({x=20,y=20})                          
   enemy_drone_class:new({x=40,y=40})                          
   enemy_frigate_class:new({x=30,y=30})
   enemy_bomber_class:new({x=100,y=100})
   particle_sun_class:new({x=30,y=100})
   particle_supernova_class:new({x=50,y=50})
   particle_earth_class:new({x=10, y=-10})
   particle_moon_class:new({x=40, y=-10})
   particle_jupiter_class:new({x=80, y=-10})
end

function game_update()
   ui_update()
   player_update()
   enemies_update()
   projectiles_update()
   particles_update()

   player_check_collision()
   player_projectiles_check_collision()

end

function game_draw()
   particles_draw()
   enemies_draw()
   player_draw()
   projectiles_draw()
   ui_draw()
end
