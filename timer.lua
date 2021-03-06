timers = {}


function create_timer(delay, func, args, loop, func_end_loop, args_end_loop)
   local timer = {
      time = delay,
      time_exec = time() + delay,
      func = func,
      args = args or {},
      loop = loop or false,
      func_end_loop = func_end_loop,
      args_end_loop = args_end_loop or {},
      passed = false
   }

   add(timers, timer)

   return timer
end


function timers_update()

   local timers_to_delete = {}
      
   for timer in all(timers) do
      if time() >= timer.time_exec then

         if timer.func ~= nil then
            if type(timer.loop) == "number" then
               timer.loop = timer.loop -1
               if timer.loop == 0 then
                  timer.func_end_loop(unpack(timer.args_end_loop))
                  add(timers_to_delete, timer)
                  timer.passed = true
               else                
                  timer.func(unpack(timer.args))
                  timer.time_exec = time() + timer.time
               end
            else 
               timer.func(unpack(timer.args))
               if type(timer.loop) == "boolean" and timer.loop == true then
                  timer.time_exec = time() + timer.time
               else
                  add(timers_to_delete, timer)
                  timer.passed = true
               end            
            end
         else
            add(timers_to_delete, timer)
            timer.passed = true
         end
      end
   end

   for timer_to_delete in all(timers_to_delete) do
      del(timers, timer_to_delete)
   end
end

function stop_timer(timer)
   del(timers,timer)
end
