with Ada.Text_Io;
with Ada.Numerics.Generic_Elementary_Functions;

procedure Three_Point_Circle is

   type Real is new Float;

   package Real_Math is
     new Ada.Numerics.Generic_Elementary_Functions (Real);

   package Real_Io is
     new Ada.Text_Io.Float_Io (Real);

   use Real_Io, Ada.Text_Io;

   -- Point P1
   X1 : constant Real := 10.0;
   Y1 : constant Real := 10.0;

   -- Point P2
   X2 : constant Real := 100.0;
   Y2 : constant Real := 200.0;

   -- Point P3
   X3 : constant Real := 200.0;
   Y3 : constant Real :=  10.0;

   -- Point P4 - midpoint between P1 and P2
   X4 : constant Real := (X1 + X2) / 2.0;
   Y4 : constant Real := (Y1 + Y2) / 2.0;
   S4 : constant Real := (Y2 - Y1) / (X2 - X1); -- Slope P1-P2
   A4 : constant Real := -1.0 / S4;             -- Slope P4-Center
   -- Y4 = A4 * X4 + B4  <=>  B4 = Y4 - A4 * X4
   B4 : constant Real := Y4 - A4 * X4;

   -- Point P5 - midpoint between P2 and P3
   X5 : constant Real := (X2 + X3) / 2.0;
   Y5 : constant Real := (Y2 + Y3) / 2.0;
   S5 : constant Real := (Y3 - Y2) / (X3 - X2); -- Slope P2-P3
   A5 : constant Real := -1.0 / S5;             -- Slope P5-Center
   -- Y5 = A5 * X5 + B5  <=>  B5 = Y5 - A5 * X5
   B5 : constant Real := Y5 - A5 * X5;

   -- Find center
   -- Y = A4 * X + B4     -- Line 1
   -- Y = A5 * X + B5     -- Line 2
   -- Solve for X:
   -- A4 * X + B4 = A5 * X + B5
   -- A4 * X - A5 * X = B5 - B4
   -- X * (A4 - A5) = B5 - B4
   -- X = (B5 - B4) / (A4 - A5)
   Xc : constant Real := (B5 - B4) / (A4 - A5);
   Yc : constant Real := A4 * Xc + B4;
   -- Radius
   R  : constant Real := Real_Math.Sqrt ((X1 - Xc) ** 2 + (Y1 - Yc) ** 2);
begin
   Real_Io.Default_Exp := 0;
   Real_Io.Default_Aft := 1;

   Put ("Center : "); Put ("("); Put (Xc);  Put (", ");  Put (Yc);  Put (")"); New_Line;
   Put ("Radius : "); Put (R);  New_Line;
end Three_Point_Circle;
