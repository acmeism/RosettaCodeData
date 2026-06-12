with Ada.Text_IO;  use Ada.Text_IO;

procedure Sum_of_Divisors is
   Sum : Positive;
   D   : Positive;
begin
   for N in 1..100 loop
      Sum := N + 1;
      D   := 2;
      while D * D <= N loop
         if N mod D = 0 Then
            Sum := Sum + D;
            if N / D /= D then
               Sum := Sum + N / D;
            end if;
         end if;
         D := D + 1;
      end loop;
      Put (Integer'Image (Sum));
   end loop;
end Sum_of_Divisors;

