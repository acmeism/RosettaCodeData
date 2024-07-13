with Ada.Numerics.Elementary_Functions;      use Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Long_Elementary_Functions; use Ada.Numerics.Long_Elementary_Functions;
with Ada.Text_IO; use Ada.Text_IO;

procedure Eulers_Constant is

   function Euler_Vacca (Iterations : Integer) return Long_Float is
      Gamma : Long_Float   := 1.0;
      Term  : Long_Float;
      Power : Long_Integer;
      Sign  : Long_Float;
   begin
      Gamma := 0.5 - (1.0 / 3.0);
      for I in 2 .. Iterations loop
         Power := 2 ** Natural (I);
         Sign  := -1.0;
         Term  := 0.0;
         for Domin in Power .. (2 * Power - 1) loop
            Sign := - (Sign);
            Term := Term + Sign / Long_Float (Domin);
         end loop;
         Gamma := Gamma + (Long_Float (I) * Term);
      end loop;
      return Gamma;
   end Euler_Vacca;

   --  Ada Float type is IEEE 754 32-bit, giving 9 decimal digits of precision
   Euler_Castellanos_Float : constant Float :=
      (((80.0 ** 3) + 92.0) /
        (61.0 ** 4))           ** (1.0 / 6.0);

   --  Ada Long_Float type is IEEE 754 32-bit, giving 14 decimal digits of precision
   Euler_Castellanos_Long_Float : constant Long_Float :=
      (990.0 ** 3 - 55.0 ** 3 - 79.0 ** 2 - 16.0) /
                  70.0 ** 5;

   Iters : Integer;
begin
   Put_Line ("Its. Vacca");
   Iters := 2;
   while Iters <= 32 loop
      Put_Line (Iters'Image & " " & Euler_Vacca (Iters)'Image);
      Iters := Iters + 2;
   end loop;
   Put_Line ("Castellanos approximation for standard Float (9 digits): " & Euler_Castellanos_Float'Image);
   Put_Line ("Castellanos approximation for Long Float (14 digits): " & Euler_Castellanos_Long_Float'Image);
end Eulers_Constant;
