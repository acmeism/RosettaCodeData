with Ada.Text_Io;
with Ada.Numerics.Generic_Elementary_Functions;

procedure Curve_Fitting is

   type Real is new Long_Float;
   type Fuction_Access is access function (X : Real) return Real;
   type Time_Type is new Natural; -- Days

   package Real_Io is new Ada.Text_Io.Float_Io (Real);
   package Math is new Ada.Numerics.Generic_Elementary_Functions (Real);

   Actual : constant array (Time_Type range <>) of Integer :=
     (27, 27, 27, 44, 44, 59, 59, 59, 59, 59, 59, 59, 59, 60, 60,
      61, 61, 66, 83, 219, 239, 392, 534, 631, 897, 1350, 2023, 2820,
      4587, 6067, 7823, 9826, 11946, 14554, 17372, 20615, 24522, 28273,
      31491, 34933, 37552, 40540, 43105, 45177, 60328, 64543, 67103,
      69265, 71332, 73327, 75191, 75723, 76719, 77804, 78812, 79339,
      80132, 80995, 82101, 83365, 85203, 87024, 89068, 90664, 93077,
      95316, 98172, 102133, 105824, 109695, 114232, 118610, 125497,
      133852, 143227, 151367, 167418, 180096, 194836, 213150, 242364,
      271106, 305117, 338133, 377918, 416845, 468049, 527767, 591704,
      656866, 715353, 777796, 851308, 928436, 1000249, 1082054, 1174652);

   N0 : constant Real := Real (Actual (Actual'First));  -- Initially infected
   K  : constant Real := 7.8e9;                         -- World population apx.

   function Logistic_Curve_Function (R : Real) return Real is
      sq  : Real := 0.0;
   begin
      for I in Actual'range loop
         declare
            Eri   : constant Real := Math.Exp (R * Real (I));
            Guess : constant Real := (N0 * Eri) / (1.0 + N0 * (Eri - 1.0) / K);
            Diff  : constant Real := Guess - Real (Actual (I));
         begin
            Sq := Sq + Diff * Diff;
         end;
      end loop;
      return sq;
   end Logistic_Curve_Function;

   procedure Solve (Func      : Fuction_Access;
                    Guess     : Real := 0.5;
                    Epsilon   : Real := 0.0;
                    New_Guess : out Real)
   is
      Delt   : Real := (if guess /= 0.0 then guess else 1.0);
      f0     : Real := Func (Guess);
      factor : Real := 2.0;
   begin
      New_Guess := Guess;
      while
        Delt > Epsilon and New_Guess /= New_Guess - Delt
      loop
         declare
            nf : real := func (New_guess - delt);
         begin
            if nf < f0 then
               f0    := nf;
               New_guess := New_guess - delt;
            else
               nf := func (New_guess + delt);
               if nf < f0 then
                  f0    := nf;
                  New_guess := New_guess + delt;
               else
                  Factor := 0.5;
               end if;
            end if;
         end;
         Delt := Delt * factor;
      end loop;
   end Solve;

   use Ada.Text_Io;

   Incubation_Time  : constant Real := 5.0; -- Days
   Contagion_Period : constant Real := 7.0; -- Days
   Generation_Time  : constant Real := Incubation_Time + Contagion_Period;

   R  : Real; -- Rate
   R0 : Real; -- Infection rate
begin
   Solve (Logistic_Curve_Function'Access, New_Guess => R);
   R0 := Math.Exp (Generation_Time * R);

   Put ("r = ");     Real_IO.Put (R,  Exp => 0, Aft => 7);
   Put (", R0 = ");  Real_Io.Put (R0, Exp => 0, Aft => 7);
   New_Line;
end Curve_Fitting;
