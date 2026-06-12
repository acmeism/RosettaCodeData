with Ada.Text_Io;

procedure Same_Digits is

   Columns : constant := 10;
   Width   : constant := 8;

   type Set_Type is array (0 .. 15) of Boolean;

   function Digit_Set_Of (N : Natural; Base : Natural) return Set_Type is
      Nn  : Natural  := N;
      Set : Set_Type := (others => False);
   begin
      while Nn /= 0 loop
         Set (Nn mod Base) := True;
         Nn := Nn / Base;
      end loop;
      return Set;
   end Digit_Set_Of;

   package Natural_Io is new Ada.Text_Io.Integer_Io (Natural);
   use Ada.Text_Io, Natural_Io;

   Count : Natural := 0;
begin
   for N in 0 .. 99_999 loop
      if Digit_Set_Of (N, Base => 10) = Digit_Set_Of (N, Base => 16) then
         Count := Count + 1;
         Put (N, Width => Width);
         if Count mod Columns = 0 then
            New_Line;
         end if;
      end if;
   end loop;
   New_Line;
   Put ("Total numbers: "); Put (Count, Width => 3); New_Line;
end Same_Digits;
