with Ada.Text_IO;  use Ada.Text_IO;

procedure Test_Events is
   -- Place the event implementation here
   X : Event;

   task A;
   task body A is
   begin
      Put_Line ("A is waiting for X");
      X.Wait;
      Put_Line ("A received X");
   end A;
begin
   delay 1.0;
   Put_Line ("Signal X");
   X.Signal;
end Test_Events;
