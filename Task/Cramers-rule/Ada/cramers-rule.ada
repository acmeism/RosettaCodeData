with Ada.Text_IO;
with Ada.Numerics.Generic_Real_Arrays;

procedure Cramers_Rules is

   type Real is new Float;
   --  This is the type we want to use in the matrix and vector

   package Real_Arrays is
      new Ada.Numerics.Generic_Real_Arrays (Real);

   use Real_Arrays;

   function Solve_Cramer (M : in Real_Matrix;
                          V : in Real_Vector)
                         return Real_Vector
   is
      Denominator : Real;
      Nom_Matrix  : Real_Matrix (M'Range (1),
                                 M'Range (2));
      Numerator   : Real;
      Result      : Real_Vector (M'Range (1));
   begin
      if
        M'Length (2) /= V'Length or
        M'Length (1) /= M'Length (2)
      then
         raise Constraint_Error with "Dimensions does not match";
      end if;

      Denominator := Determinant (M);

      for Col in V'Range loop
         Nom_Matrix := M;

         --  Substitute column
         for Row in V'Range loop
            Nom_Matrix (Row, Col) := V (Row);
         end loop;

         Numerator    := Determinant (Nom_Matrix);
         Result (Col) := Numerator / Denominator;
      end loop;

      return Result;
   end Solve_Cramer;

   procedure Put (V : Real_Vector) is
      use Ada.Text_IO;
      package Real_IO is
         new Ada.Text_IO.Float_IO (Real);
   begin
      Put ("[");
      for E of V loop
         Real_IO.Put (E, Exp => 0, Aft => 2);
         Put (" ");
      end loop;
      Put ("]");
      New_Line;
   end Put;

   M : constant Real_Matrix := ((2.0, -1.0,  5.0,  1.0),
                                (3.0,  2.0,  2.0, -6.0),
                                (1.0,  3.0,  3.0, -1.0),
                                (5.0, -2.0, -3.0,  3.0));
   V : constant Real_Vector := (-3.0, -32.0, -47.0, 49.0);
   R : constant Real_Vector := Solve_Cramer (M, V);
begin
   Put (R);
end Cramers_Rules;
