with Ada.Text_IO;

procedure Chowla_Numbers is

   function Chowla (N : Positive) return Natural is
      Sum : Natural  := 0;
      I   : Positive := 2;
      J   : Positive;
   begin
      while I * I <= N loop
         if N mod I = 0 then
            J   := N / I;
            Sum := Sum + I + (if I = J then 0 else J);
            end if;
            I := I + 1;
      end loop;
      return Sum;
   end Chowla;

   procedure Put_37_First is
      use Ada.Text_IO;
   begin
      for A in Positive range 1 .. 37 loop
         Put_Line ("chowla(" & A'Image & ") = " & Chowla (A)'Image);
      end loop;
   end Put_37_First;

   procedure Put_Prime is
      use Ada.Text_IO;
      Count : Natural  := 0;
      Power : Positive := 100;
   begin
      for N in Positive range 2 .. 10_000_000 loop
         if Chowla (N) = 0 then
            Count := Count + 1;
         end if;
         if N mod Power = 0 then
            Put_Line ("There are " & Count'Image & " primes < " & Power'Image);
            Power := Power * 10;
         end if;
      end loop;
   end Put_Prime;

   procedure Put_Perfect is
      use Ada.Text_IO;
      Count : Natural  := 0;
      Limit : constant := 350_000_000;
      K     : Natural := 2;
      Kk    : Natural := 3;
      P     : Natural;
   begin
      loop
         P := K * Kk;
         exit when P > Limit;

         if Chowla (P) = P - 1 then
            Put_Line (P'Image & " is a perfect number");
            Count := Count + 1;
         end if;
         K  := Kk + 1;
         Kk := Kk + K;
      end loop;
      Put_Line ("There are " & Count'Image & " perfect numbers < " & Limit'Image);
   end Put_Perfect;

begin
   Put_37_First;
   Put_Prime;
   Put_Perfect;
end Chowla_Numbers;
