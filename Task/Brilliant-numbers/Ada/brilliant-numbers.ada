with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Text_IO;                       use Ada.Text_IO;

procedure Brilliant_Numbers is
   subtype Prime_Numbers is Positive range 2 .. 10_000_000 with
      Dynamic_Predicate => (for all I in 2 .. (Prime_Numbers / 2)
         => (Prime_Numbers mod I) /= 0);

   Count, N, FPF, SF, Expo : Integer := 0;

   function First_Prime_Factor (N : Integer) return Integer is
      I : Integer := 3;
   begin
      if N mod 2 = 0 then
         return 2;
      end if;
      while I < Integer (Sqrt (Float (N)) + 1.0) loop
         if N mod I = 0 then
            return I;
         end if;
         I := I + 2;
      end loop;
      return N;
   end First_Prime_Factor;

begin
   while Count < 100 loop
      FPF := First_Prime_Factor (N);
      SF  := N / FPF;
      if SF in Prime_Numbers and then FPF'Image'Length = SF'Image'Length then
         Put (N'Image);
         Count := Count + 1;
         if Count mod 6 = 0 then
            New_Line;
         end if;
      end if;
      N := N + 1;
   end loop;

   Count := 0;
   N := 0;
   loop
      FPF := First_Prime_Factor (N);
      SF := N / FPF;
      if SF in Prime_Numbers and then FPF'Image'Length = SF'Image'Length then
         Count := Count + 1;
         if N > 10 ** Expo then
            Put_Line (N'Image & " is brilliant number:" & Count'Image);
            Expo := Expo + 1;
            exit when Expo = 7;
         end if;
      end if;
      N := N + 1;
   end loop;

end Brilliant_Numbers;
