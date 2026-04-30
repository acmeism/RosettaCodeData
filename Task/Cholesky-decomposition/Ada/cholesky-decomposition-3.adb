with Ada.Numerics.Real_Arrays;
with Ada.Text_IO;
with Decomposition;
procedure Decompose_Example is
   package Real_Decomposition is new Decomposition
     (Matrix => Ada.Numerics.Real_Arrays);

   package Real_IO is new Ada.Text_IO.Float_IO (Float);

   procedure Print (M : Ada.Numerics.Real_Arrays.Real_Matrix) is
   begin
      for Row in M'Range (1) loop
         for Col in M'Range (2) loop
            Real_IO.Put (M (Row, Col), 4, 3, 0);
         end loop;
         Ada.Text_IO.New_Line;
      end loop;
   end Print;

   Example_1 : constant Ada.Numerics.Real_Arrays.Real_Matrix :=
     ((25.0, 15.0, -5.0),
      (15.0, 18.0, 0.0),
      (-5.0, 0.0, 11.0));
   L_1 : Ada.Numerics.Real_Arrays.Real_Matrix (Example_1'Range (1),
                                               Example_1'Range (2));
   Example_2 : constant Ada.Numerics.Real_Arrays.Real_Matrix :=
     ((18.0, 22.0, 54.0, 42.0),
      (22.0, 70.0, 86.0, 62.0),
      (54.0, 86.0, 174.0, 134.0),
      (42.0, 62.0, 134.0, 106.0));
   L_2 : Ada.Numerics.Real_Arrays.Real_Matrix (Example_2'Range (1),
                                               Example_2'Range (2));
begin
   Real_Decomposition.Decompose (A => Example_1,
                                 L => L_1);
   Real_Decomposition.Decompose (A => Example_2,
                                 L => L_2);
   Ada.Text_IO.Put_Line ("Example 1:");
   Ada.Text_IO.Put_Line ("A:"); Print (Example_1);
   Ada.Text_IO.Put_Line ("L:"); Print (L_1);
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("Example 2:");
   Ada.Text_IO.Put_Line ("A:"); Print (Example_2);
   Ada.Text_IO.Put_Line ("L:"); Print (L_2);
end Decompose_Example;
