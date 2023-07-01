with Ada.Task_Identification;  use Ada.Task_Identification;

procedure Main is
   -- Create as many task objects as your program needs
begin
   -- whatever logic is required in your Main procedure
   if some_condition then
      Abort_Task (Current_Task);
   end if;
end Main;
