task body Some_Task is
begin
   loop
      select
         -- Some alternatives
         ...
      or accept Stop do
            -- Some cleanup while holding the caller is here
         end Stop;
            -- A cleanup asynchronous to the caller is here
         exit; -- We are through
      end select
   end loop;
end Some_Task;
