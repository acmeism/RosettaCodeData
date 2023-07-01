with Ada.Text_IO;
with Ada.Numerics.Generic_Real_Arrays;

procedure Gaussian_Eliminations is

   type Real is new Float;

   package Real_Arrays is
      new Ada.Numerics.Generic_Real_Arrays (Real);
   use Real_Arrays;

   function Gaussian_Elimination (A : in Real_Matrix;
                                  B : in Real_Vector) return Real_Vector
   is

      procedure Swap_Row (A        : in out Real_Matrix;
                          B        : in out Real_Vector;
                          R_1, R_2 : in     Integer)
      is
         Temp : Real;
      begin
         if R_1 = R_2 then return; end if;

         --  Swal matrix row
         for Col in A'Range (1) loop
            Temp := A (R_1, Col);
            A (R_1, Col) := A (R_2, Col);
            A (R_2, Col) := Temp;
         end loop;

         --  Swap vector row
         Temp    := B (R_1);
         B (R_1) := B (R_2);
         B (R_2) := Temp;
      end Swap_Row;

      AC : Real_Matrix := A;
      BC : Real_Vector := B;
      X  : Real_Vector (A'Range (1)) := BC;
      Max, Tmp : Real;
      Max_Row  : Integer;
   begin
      if
        A'Length (1) /= A'Length (2) or
        A'Length (1) /= B'Length
      then
         raise Constraint_Error with "Dimensions do not match";
      end if;

      if
        A'First (1) /= A'First (2) or
        A'First (1) /= B'First
      then
         raise Constraint_Error with "First index must be same";
      end if;

      for Dia in Ac'Range (1) loop
         Max_Row := Dia;
         Max     := Ac (Dia, Dia);

         for Row in Dia + 1 .. Ac'Last (1) loop
            Tmp := abs (Ac (Row, Dia));
            if Tmp > Max then
               Max_Row := Row;
               Max     := Tmp;
            end if;
         end loop;
         Swap_Row (Ac, Bc, Dia, Max_Row);

         for Row in Dia + 1 .. Ac'Last (1) loop
            Tmp := Ac (Row, Dia) / Ac (Dia, Dia);
            for Col in Dia + 1 .. Ac'Last (1) loop
               Ac (Row, Col) := Ac (Row, Col) - Tmp * Ac (Dia, Col);
            end loop;
            Ac (Row, Dia) := 0.0;
            Bc (Row) := Bc (Row) - Tmp * Bc (Dia);
         end loop;
      end loop;

      for Row in reverse Ac'Range (1) loop
         Tmp := Bc (Row);
         for J in reverse Row + 1 .. Ac'Last (1) loop
            Tmp := Tmp - X (J) * Ac (Row, J);
         end loop;
         X (Row) := Tmp / Ac (Row, Row);
      end loop;

      return X;
   end Gaussian_Elimination;

   procedure Put (V : in Real_Vector) is
      use Ada.Text_IO;
      package Real_IO is
         new Ada.Text_IO.Float_IO (Real);
   begin
      Put ("[ ");
      for E of V loop
         Real_IO.Put (E, Exp => 0, Aft => 6);
         Put (" ");
      end loop;
      Put (" ]");
      New_Line;
   end Put;

   A : constant Real_Matrix :=
     ((1.00, 0.00, 0.00,  0.00,  0.00, 0.00),
      (1.00, 0.63, 0.39,  0.25,  0.16, 0.10),
      (1.00, 1.26, 1.58,  1.98,  2.49, 3.13),
      (1.00, 1.88, 3.55,  6.70, 12.62, 23.80),
      (1.00, 2.51, 6.32, 15.88, 39.90, 100.28),
      (1.00, 3.14, 9.87, 31.01, 97.41, 306.02));

   B : constant Real_Vector :=
     ( -0.01, 0.61, 0.91, 0.99, 0.60, 0.02 );

   X : constant Real_Vector := Gaussian_Elimination (A, B);
begin
   Put (X);
end Gaussian_Eliminations;
