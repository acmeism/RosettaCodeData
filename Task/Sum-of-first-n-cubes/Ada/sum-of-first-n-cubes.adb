with Ada.Text_Io;

procedure Sum_Of_First_N_Cubes is

   Columns : constant := 10;
   Width   : constant := 8;

   package Natural_Io is new Ada.Text_Io.Integer_Io (Natural);
   use Ada.Text_Io, Natural_Io;

   Sum : Natural := 0;
begin
   for N in 0 .. 49 loop
      Sum := Sum + N ** 3;
      Put (Sum, Width => Width);
      if N mod Columns = Columns - 1 then
         New_Line;
      end if;
   end loop;
   New_Line;
end Sum_Of_First_N_Cubes;
