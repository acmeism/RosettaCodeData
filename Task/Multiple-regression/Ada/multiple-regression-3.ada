with Ada.Text_IO;
with Matrices;
procedure Multiple_Regression is
   package Float_Matrices is new Matrices (
      Element_Type => Float,
      Zero => 0.0,
      One => 1.0);
   subtype Vector is Float_Matrices.Vector;
   subtype Matrix is Float_Matrices.Matrix;
   use type Matrix;

   procedure Output_Matrix (X : Matrix) is
   begin
      for Row in X'Range (1) loop
         for Col in X'Range (2) loop
            Ada.Text_IO.Put (Float'Image (X (Row, Col)) & ' ');
         end loop;
         Ada.Text_IO.New_Line;
      end loop;
   end Output_Matrix;

   -- example from Ruby solution
   V : constant Vector := (1.0, 2.0, 3.0, 4.0, 5.0);
   M : constant Matrix :=
     ((1 => 2.0),
      (1 => 1.0),
      (1 => 3.0),
      (1 => 4.0),
      (1 => 5.0));
   C : constant Vector :=
      Float_Matrices.Regression_Coefficients (Source => V, Regressors => M);
   -- Wikipedia example
   Weight        : constant Vector (1 .. 15) :=
     (52.21, 53.12, 54.48, 55.84, 57.20,
      58.57, 59.93, 61.29, 63.11, 64.47,
      66.28, 68.10, 69.92, 72.19, 74.46);
   Height        : Vector (1 .. 15)          :=
     (1.47, 1.50, 1.52, 1.55, 1.57,
      1.60, 1.63, 1.65, 1.68, 1.70,
      1.73, 1.75, 1.78, 1.80, 1.83);
   Height_Matrix : Matrix (1 .. 15, 1 .. 3);
begin
   Ada.Text_IO.Put_Line ("Example from Ruby solution:");
   Ada.Text_IO.Put_Line ("V:");
   Output_Matrix (Float_Matrices.To_Matrix (V));
   Ada.Text_IO.Put_Line ("M:");
   Output_Matrix (M);
   Ada.Text_IO.Put_Line ("C:");
   Output_Matrix (Float_Matrices.To_Matrix (C));
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("Example from Wikipedia:");
   for I in Height'Range loop
      Height_Matrix (I, 1) := 1.0;
      Height_Matrix (I, 2) := Height (I);
      Height_Matrix (I, 3) := Height (I) ** 2;
   end loop;
   Ada.Text_IO.Put_Line ("Matrix:");
   Output_Matrix (Height_Matrix);
   declare
      Coefficients : constant Vector :=
         Float_Matrices.Regression_Coefficients
           (Source     => Weight,
            Regressors => Height_Matrix);
   begin
      Ada.Text_IO.Put_Line ("Coefficients:");
      Output_Matrix (Float_Matrices.To_Matrix (Coefficients));
   end;
end Multiple_Regression;
