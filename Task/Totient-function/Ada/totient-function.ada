with Ada.Text_IO;
with Ada.Integer_Text_IO;

procedure Totient is

   function Totient (N : in Integer) return Integer is
      Tot : Integer := N;
      I   : Integer;
      N2  : Integer := N;
   begin
      I := 2;
      while I * I <= N2 loop
         if N2 mod I = 0 then
            while N2 mod I = 0 loop
               N2 := N2 / I;
            end loop;
            Tot := Tot - Tot / I;
         end if;

         if I = 2 then
            I := 1;
         end if;
         I := I + 2;
      end loop;

      if N2 > 1 then
         Tot := Tot - Tot / N2;
      end if;

      return Tot;
   end Totient;

   Count : Integer := 0;
   Tot   : Integer;
   Placeholder : String := "  n  Phi  Is_Prime";
   Image_N     : String renames Placeholder ( 1 ..  3);
   Image_Phi   : String renames Placeholder ( 6 ..  8);
   Image_Prime : String renames Placeholder (11 .. 17);
   use Ada.Text_IO;
   use Ada.Integer_Text_IO;
begin

   Put_Line (Placeholder);

   for N in 1 .. 25 loop
      Tot := Totient (N);

      if N - 1 = Tot then
         Count := Count + 1;
      end if;
      Put (Image_N, N);
      Put (Image_Phi, Tot);
      Image_Prime := (if N - 1 = Tot then "    True" else "   False");
      Put_Line (Placeholder);
   end loop;
   New_Line;

   Put_Line ("Number of primes up to " & Integer'(25)'Image &" =" & Count'Image);

   for N in 26 .. 100_000 loop
      Tot := Totient (N);

      if Tot = N - 1 then
         Count := Count + 1;
      end if;

      if N = 100 or N = 1_000 or N mod 10_000 = 0 then
         Put_Line ("Number of primes up to " & N'Image & " =" & Count'Image);
      end if;
   end loop;

end Totient;
