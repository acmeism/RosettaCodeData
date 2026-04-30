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
            Real_IO.Put (M (Row, Col), 3, 2, 0);
         end loop;
         Ada.Text_IO.New_Line;
      end loop;
   end Print;

   Example_1 : constant Ada.Numerics.Real_Arrays.Real_Matrix :=
     ((1.0, 3.0, 5.0),
      (2.0, 4.0, 7.0),
      (1.0, 1.0, 0.0));
   P_1, L_1, U_1 : Ada.Numerics.Real_Arrays.Real_Matrix (Example_1'Range (1),
                                                         Example_1'Range (2));
   Example_2 : constant Ada.Numerics.Real_Arrays.Real_Matrix :=
     ((11.0, 9.0, 24.0, 2.0),
      (1.0, 5.0, 2.0, 6.0),
      (3.0, 17.0, 18.0, 1.0),
      (2.0, 5.0, 7.0, 1.0));
   P_2, L_2, U_2 : Ada.Numerics.Real_Arrays.Real_Matrix (Example_2'Range (1),
                                                         Example_2'Range (2));
begin
   Real_Decomposition.Decompose (A => Example_1,
                                 P => P_1,
                                 L => L_1,
                                 U => U_1);
   Real_Decomposition.Decompose (A => Example_2,
                                 P => P_2,
                                 L => L_2,
                                 U => U_2);
   Ada.Text_IO.Put_Line ("Example 1:");
   Ada.Text_IO.Put_Line ("A:"); Print (Example_1);
   Ada.Text_IO.Put_Line ("L:"); Print (L_1);
   Ada.Text_IO.Put_Line ("U:"); Print (U_1);
   Ada.Text_IO.Put_Line ("P:"); Print (P_1);
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("Example 2:");
   Ada.Text_IO.Put_Line ("A:"); Print (Example_2);
   Ada.Text_IO.Put_Line ("L:"); Print (L_2);
   Ada.Text_IO.Put_Line ("U:"); Print (U_2);
   Ada.Text_IO.Put_Line ("P:"); Print (P_2);
end Decompose_Example;
