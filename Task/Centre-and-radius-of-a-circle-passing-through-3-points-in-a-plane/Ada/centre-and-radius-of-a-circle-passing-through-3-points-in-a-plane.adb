with Ada.Text_IO;
with Ada.Numerics.Generic_Elementary_Functions;

procedure Program
is
   type Real is digits 2;

   package Real_IO is
     new Ada.Text_IO.Float_IO (Real);
   package Math is
     new Ada.Numerics.Generic_Elementary_Functions (Real);

   type Point is record
      X, Y : Real'Base;
   end record;

   procedure Find_Circle (P1, P2, P3 : in  Point;
                          Center     : out Point;
                          Radius     : out Real)
   is
      use Math;
      X_12 : constant Real'Base := P1.X - P2.X;
      X_13 : constant Real'Base := P1.X - P3.X;
      Y_12 : constant Real'Base := P1.Y - P2.Y;
      Y_13 : constant Real'Base := P1.Y - P3.Y;
      Y_31 : constant Real'Base := P3.Y - P1.Y;
      Y_21 : constant Real'Base := P2.Y - P1.Y;
      X_31 : constant Real'Base := P3.X - P1.X;
      X_21 : constant Real'Base := P2.X - P1.X;

      SX_13 : constant Real'Base := P1.X**2 - P3.X**2;
      SY_13 : constant Real'Base := P1.Y**2 - P3.Y**2;
      SX_21 : constant Real'Base := P2.X**2 - P1.X**2;
      SY_21 : constant Real'Base := P2.Y**2 - P1.Y**2;

      F : constant Real'Base
        := (SX_13 * X_12 + SY_13 * X_12 + SX_21 * X_13 + SY_21 * X_13)
            / (2.0 * (Y_31 * X_12 - Y_21 * X_13));
      G : constant Real'Base
        := (SX_13 * Y_12 + SY_13 * Y_12 + SX_21 * Y_13 + SY_21 * Y_13)
            / (2.0 * (X_31 * Y_12 - X_21 * Y_13));

      C : constant Real'Base
        := -(P1.X**2) - P1.Y**2 - 2.0 * G * P1.X - 2.0 * F * P1.Y;
      H : constant Real'Base := -G;
      K : constant Real'Base := -F;
      R : constant Real'Base := Sqrt (H * H + K * K - C);
   begin
      Center.X := H;
      Center.Y := K;
      Radius   := R;
   end Find_Circle;

   use Ada.Text_IO;
   Center : Point;
   Radius : Real'Base;
begin
   Real_IO.Default_Aft := 2;
   Real_IO.Default_Exp := 0;

   Find_Circle ((22.83, 2.07), (14.39, 30.24), (33.65, 17.31),
                Center, Radius);

   Put ("Center is at ("); Real_IO.Put (Center.X);
   Put (", ");             Real_IO.Put (Center.Y);
   Put (")");
   New_Line;

   Put ("Radius is ");    Real_IO.Put (Radius);
   New_Line;
end Program;
