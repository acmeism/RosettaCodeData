with Ada.Numerics.Generic_Elementary_Functions;

package body Apollonius is
   package Math is new Ada.Numerics.Generic_Elementary_Functions
     (Long_Float);

   function Solve_CCC
     (Circle_1, Circle_2, Circle_3 : Circle;
      T1, T2, T3                   : Tangentiality := External)
      return                         Circle
   is
      S1 : Long_Float := 1.0;
      S2 : Long_Float := 1.0;
      S3 : Long_Float := 1.0;

      X1 : Long_Float renames Circle_1.Center.X;
      Y1 : Long_Float renames Circle_1.Center.Y;
      R1 : Long_Float renames Circle_1.Radius;

      X2 : Long_Float renames Circle_2.Center.X;
      Y2 : Long_Float renames Circle_2.Center.Y;
      R2 : Long_Float renames Circle_2.Radius;

      X3 : Long_Float renames Circle_3.Center.X;
      Y3 : Long_Float renames Circle_3.Center.Y;
      R3 : Long_Float renames Circle_3.Radius;
   begin
      if T1 = Internal then
         S1 := -S1;
      end if;
      if T2 = Internal then
         S2 := -S2;
      end if;
      if T3 = Internal then
         S3 := -S3;
      end if;

      declare
         V11 : constant Long_Float := 2.0 * X2 - 2.0 * X1;
         V12 : constant Long_Float := 2.0 * Y2 - 2.0 * Y1;
         V13 : constant Long_Float :=
           X1 * X1 - X2 * X2 + Y1 * Y1 - Y2 * Y2 - R1 * R1 + R2 * R2;
         V14 : constant Long_Float := 2.0 * S2 * R2 - 2.0 * S1 * R1;

         V21 : constant Long_Float := 2.0 * X3 - 2.0 * X2;
         V22 : constant Long_Float := 2.0 * Y3 - 2.0 * Y2;
         V23 : constant Long_Float :=
           X2 * X2 - X3 * X3 + Y2 * Y2 - Y3 * Y3 - R2 * R2 + R3 * R3;
         V24 : constant Long_Float := 2.0 * S3 * R3 - 2.0 * S2 * R2;

         W12 : constant Long_Float := V12 / V11;
         W13 : constant Long_Float := V13 / V11;
         W14 : constant Long_Float := V14 / V11;

         W22 : constant Long_Float := V22 / V21 - W12;
         W23 : constant Long_Float := V23 / V21 - W13;
         W24 : constant Long_Float := V24 / V21 - W14;

         P   : constant Long_Float := -W23 / W22;
         Q   : constant Long_Float := W24 / W22;
         M   : constant Long_Float := -W12 * P - W13;
         N   : constant Long_Float := W14 - W12 * Q;

         A   : constant Long_Float := N * N + Q * Q - 1.0;
         B   : constant Long_Float :=
           2.0 * M * N -
             2.0 * N * X1 +
               2.0 * P * Q -
                 2.0 * Q * Y1 +
                   2.0 * S1 * R1;
         C   : constant Long_Float :=
           X1 * X1 +
             M * M -
               2.0 * M * X1 +
                 P * P +
                   Y1 * Y1 -
                     2.0 * P * Y1 -
                       R1 * R1;

         D   : constant Long_Float := B * B - 4.0 * A * C;
         RS  : constant Long_Float := (-B - Math.Sqrt (D)) / (2.0 * A);
      begin
         return (Center => (X => M + N * RS, Y => P + Q * RS), Radius => RS);
      end;
   end Solve_CCC;
end Apollonius;
