with Ada.Text_IO;
with Apollonius;

procedure Test_Apollonius is
   use Apollonius;
   package Long_Float_IO is new Ada.Text_IO.Float_IO (Long_Float);

   C1 : constant Circle := (Center => (X => 0.0, Y => 0.0), Radius => 1.0);
   C2 : constant Circle := (Center => (X => 4.0, Y => 0.0), Radius => 1.0);
   C3 : constant Circle := (Center => (X => 2.0, Y => 4.0), Radius => 2.0);

   R1 : Circle := Solve_CCC (C1, C2, C3, External, External, External);
   R2 : Circle := Solve_CCC (C1, C2, C3, Internal, Internal, Internal);
begin
   Ada.Text_IO.Put_Line ("R1:");
   Long_Float_IO.Put (R1.Center.X, Aft => 3, Exp => 0);
   Long_Float_IO.Put (R1.Center.Y, Aft => 3, Exp => 0);
   Long_Float_IO.Put (R1.Radius, Aft => 3, Exp => 0);
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("R2:");
   Long_Float_IO.Put (R2.Center.X, Aft => 3, Exp => 0);
   Long_Float_IO.Put (R2.Center.Y, Aft => 3, Exp => 0);
   Long_Float_IO.Put (R2.Radius, Aft => 3, Exp => 0);
   Ada.Text_IO.New_Line;
end Test_Apollonius;
