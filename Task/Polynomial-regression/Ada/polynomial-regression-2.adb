with Fit;
with Ada.Float_Text_IO;  use Ada.Float_Text_IO;

procedure Fitting is
   C : constant Real_Vector :=
          Fit
          (  (0.0, 1.0,  2.0,  3.0,  4.0,  5.0,   6.0,   7.0,   8.0,   9.0,  10.0),
             (1.0, 6.0, 17.0, 34.0, 57.0, 86.0, 121.0, 162.0, 209.0, 262.0, 321.0),
             2
          );
begin
   Put (C (0), Aft => 3, Exp => 0);
   Put (C (1), Aft => 3, Exp => 0);
   Put (C (2), Aft => 3, Exp => 0);
end Fitting;
