task body Some_Task is
begin
   loop
      select
         -- Some alternatives
         ...
      or terminate; -- We are through
      end select
   end loop;
end Some_Task;
