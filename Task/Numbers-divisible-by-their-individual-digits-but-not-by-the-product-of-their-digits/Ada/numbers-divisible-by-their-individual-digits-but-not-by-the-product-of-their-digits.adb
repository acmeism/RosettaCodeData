with Ada.Text_Io;
with Ada.Integer_Text_Io;

procedure Numbers_Divisible is

   function Is_Divisible (N : Natural) return Boolean is

      function To_Decimal (C : Character) return Natural
      is ( Character'Pos (C) - Character'Pos ('0'));

      Image : constant String := N'Image;
      Digit : Natural;
      Prod  : Natural := 1;
   begin
      for A in Image'First + 1 .. Image'Last loop
         Digit := To_Decimal (Image (A));
         if Digit = 0 then
            return False;
         end if;
         if N mod Digit /= 0 then
            return False;
         end if;
         Prod := Prod * Digit;
      end loop;
      return N mod Prod /= 0;
   end Is_Divisible;

   Count : Natural := 0;
begin
   for N in 1 .. 999 loop
      if Is_Divisible (N) then
         Count := Count + 1;
         Ada.Integer_Text_Io.Put (N, Width => 5);
         if Count mod 15 = 0 then
            Ada.Text_Io.New_Line;
         end if;
      end if;
   end loop;
end Numbers_Divisible;
