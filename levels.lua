level_galaxy1={
   name="galaxy 1",
   content={
      {particle_supernova_class,"new",{x=50,y=50}},
      {powerup_multi_laser_class,"new",{x=30,y=-10}},
      {powerup_missile_class,"new",{x=40,y=-10}},
      {powerup_shield_plus_class,"new",{x=50,y=-10}},
      {powerup_shield_plus_class,"new",{x=60,y=-10}},
      {powerup_life_class,"new",{x=70,y=-10}},
      {3},
      {enemy_raider_class,"new",{x=63,y=-10,
                                 waypoints={
                                    {x=63,y=10},
                                    {x=118,y=63, bc={x=128,y=0,num=10} },
                                    {x=63,y=118, bc={x=128,y=128,num=10} },
                                    {x=10,y=63,  bc={x=0,y=128,num=10} },
                                    {x=63,y=10,  bc={x=0,y=0,num=10} }
                                 }    
                                }
      },
      {enemy_drone_class,"new",{x=20,y=-10,
                                waypoints={
                                    {x=20,y=10},
                                    {x=30,y=23},
                                    {x=30,y=150},
                                 }
                               }
      }, 
      {0},
      {-1},
      {powerup_phaser_class,"new",{x=30,y=-10}},
      {3},
      {particle_moon_class,"new",{x=40, y=-10}},
      {3},
      {enemy_frigate_class,"new",{x=60,y=-10,
                                  waypoints={
                                     {x=60,y=30}
                                  }
                                 }
      },
      {enemy_bomber_class,"new",{x=-10,y=50,
                                 waypoints={
                                     {x=150,y=50}
                                  }
                                }
      }   
   }
}

