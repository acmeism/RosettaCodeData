with Matrices;
with Ada.Text_IO;
procedure Main is
   package Float_IO is new Ada.Text_IO.Float_IO (Float);
   package Float_Matrices is new Matrices (
      Element_Type => Float,
      Zero => 0.0);
   procedure Print_Matrix (Matrix : in Float_Matrices.Matrix) is
   begin
      for Row in Matrix'Range (1) loop
         for Col in Matrix'Range (2) loop
            Float_IO.Put (Matrix (Row, Col), 0, 0, 0);
            Ada.Text_IO.Put (' ');
         end loop;
         Ada.Text_IO.New_Line;
      end loop;
   end Print_Matrix;
   My_Matrix : Float_Matrices.Matrix :=
     ((1.0, 2.0, -1.0, -4.0),
      (2.0, 3.0, -1.0, -11.0),
      (-2.0, 0.0, -3.0, 22.0));
   Reduced   : Float_Matrices.Matrix :=
      Float_Matrices.Reduced_Row_Echelon_form (My_Matrix);
begin
   Print_Matrix (My_Matrix);
   Ada.Text_IO.Put_Line ("reduced to:");
   Print_Matrix (Reduced);
end Main;
