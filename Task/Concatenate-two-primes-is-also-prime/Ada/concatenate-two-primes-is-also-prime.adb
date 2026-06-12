with Ada.Text_Io;
with Ada.Integer_Text_Io;
with Ada.Strings.Fixed;

procedure Concat_Is_Prime is

   Columns : constant := 10;

   subtype Full_Range is Integer range 2 .. 9_999;
   subtype Low_Range  is Full_Range range Full_Range'First .. 99;

   function Concat (Left, Right : Low_Range) return Full_Range is
      use Ada.Strings;
   begin
      return Full_Range'Value (Fixed.Trim (Left'Image, Both) &
                                  Fixed.Trim (Right'Image, Both));
   end Concat;

   use Ada.Text_Io, Ada.Integer_Text_Io;

   Is_Prime        : array (Full_Range) of Boolean := (others => True);
   Is_Concat_Prime : array (Full_Range) of Boolean := (others => False);
   Count           : Natural := 0;

begin
   for A in Full_Range loop
      if Is_Prime (A) then
         for B in 2 .. Integer'Last loop
            exit when A * B not in Full_Range;
            Is_Prime (A * B) := False;
         end loop;
      end if;
   end loop;

   for P1 in Low_Range loop
      for P2 in Low_Range loop
         if
           Is_Prime (P1) and Is_Prime (P2) and Is_Prime (Concat (P1, P2))
         then
            Is_Concat_Prime (Concat (P1, P2)) := True;
         end if;
      end loop;
   end loop;

   for A in Is_Concat_Prime'Range loop
      if Is_Concat_Prime (A) then
         Put (A, Width => 6);
         Count := Count + 1;
         if Count mod Columns = 0 then
            New_Line;
         end if;
      end if;
   end loop;
   New_Line;

   Put ("There are ");
   Put (Natural'Image (Count));
   Put (" concat primes.");
   New_Line;
end Concat_Is_Prime;
