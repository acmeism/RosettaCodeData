-- Use the Arithmetic-geometric mean to calculate Pi
-- J. Carter     2024 May

with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Text_IO;
with System;

procedure AGM_Pi is
   type Real is digits System.Max_Digits;

   package Math is new Ada.Numerics.Generic_Elementary_Functions (Float_Type => Real);

   A       : Real := 1.0;
   B       : Real := Math.Sqrt (0.5);
   T       : Real := 0.25;
   N       : Real := 1.0;
   Prev_A  : Real;
   Pi      : Real;
   Prev_Pi : Real := 0.0;
begin -- AGM_Pi
   Calculate : loop
      Prev_A := A;
      A := (A + B) / 2.0;
      B := Math.Sqrt (Prev_A * B);
      T := T - N * (A - Prev_A) ** 2;
      N := N + N;
      Pi := (A + B) ** 2 / (4.0 * T);
      Ada.Text_IO.Put_Line (Item => Pi'Image);

      exit Calculate when abs (Prev_Pi - Pi) < 10.0 ** (-(Real'Digits - 1) );

      Prev_Pi := Pi;
   end loop Calculate;
end AGM_Pi;
