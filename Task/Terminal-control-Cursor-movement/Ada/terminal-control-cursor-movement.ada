with Ada.Text_Io;

with Ansi;

procedure Movement is
   use Ada.Text_Io;
begin
   Put (Ansi.Store);
   Put (Ansi.Position (Row => 20, Column => 40));

   for A in 1 .. 15 loop
      Put (Ansi.Back);
      delay 0.020;
   end loop;

   for A in 1 .. 15 loop
      Put (Ansi.Up);
      delay 0.050;
   end loop;

   for A in 1 .. 15 loop
      Put (Ansi.Forward);
      delay 0.020;
   end loop;

   for A in 1 .. 15 loop
      Put (Ansi.Down);
      delay 0.050;
   end loop;

   delay 1.000;
   Put (Ansi.Horizontal (Column => 1));
   delay 2.000;
   Put (Ansi.Position (1, 1));
   delay 2.000;
   Put (Ansi.Restore);
end Movement;
