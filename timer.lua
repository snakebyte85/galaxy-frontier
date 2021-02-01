timers = {}


function create_timer(delay, func, args, loop)

   local timer = {
      time = delay,
      time_exec = time() + delay,
      func = func,
      args = args,
      loop = loop or false,
      passed = false
   }

   add(timers, timer)

   return timer
end


function timers_update()

   local timers_to_delete = {}
      
   for timer in all(timers) do
      if time() >= timer.time_exec then

         if timer.args == nil then
            timer.args = {}
         end

         if timer.func ~= nil then
            timer.func(unpack(timer.args))
         end

         if timer.loop then
            timer.time_exec = time() + timer.time
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
