procedure Main is
   -- Create as many task objects as your program needs
begin
   -- whatever logic is required in your Main procedure
   if some_condition then
      -- for each task created by the Main procedure
      The_task.Stop;
      -- end the Main procedure
      return;  -- actually, this is not needed
   end if;
end Main;
