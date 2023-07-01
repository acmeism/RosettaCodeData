package body Decomposition is

   procedure Swap_Rows (M : in out Matrix.Real_Matrix; From, To : Natural) is
      Temporary : Matrix.Real;
   begin
      if From = To then
         return;
      end if;
      for I in M'Range (2) loop
         Temporary := M (M'First (1) + From, I);
         M (M'First (1) + From, I) := M (M'First (1) + To, I);
         M (M'First (1) + To, I) := Temporary;
      end loop;
   end Swap_Rows;

   function Pivoting_Matrix
     (M : Matrix.Real_Matrix)
      return Matrix.Real_Matrix
   is
      use type Matrix.Real;
      Order     : constant Positive := M'Length (1);
      Result    : Matrix.Real_Matrix := Matrix.Unit_Matrix (Order);
      Max       : Matrix.Real;
      Row       : Natural;
   begin
      for J in 0 .. Order - 1 loop
         Max := M (M'First (1) + J, M'First (2) + J);
         Row := J;
         for I in J .. Order - 1 loop
            if M (M'First (1) + I, M'First (2) + J) > Max then
               Max := M (M'First (1) + I, M'First (2) + J);
               Row := I;
            end if;
         end loop;
         if J /= Row then
            -- swap rows J and Row
            Swap_Rows (Result, J, Row);
         end if;
      end loop;
      return Result;
   end Pivoting_Matrix;

   procedure Decompose (A : Matrix.Real_Matrix; P, L, U : out Matrix.Real_Matrix) is
      use type Matrix.Real_Matrix, Matrix.Real;
      Order : constant Positive := A'Length (1);
      A2 : Matrix.Real_Matrix (A'Range (1), A'Range (2));
      S : Matrix.Real;
   begin
      L := (others => (others => 0.0));
      U := (others => (others => 0.0));
      P := Pivoting_Matrix (A);
      A2 := P * A;
      for J in 0 .. Order - 1 loop
         L (L'First (1) + J, L'First (2) + J) := 1.0;
         for I in 0 .. J loop
            S := 0.0;
            for K in 0 .. I - 1 loop
               S := S + U (U'First (1) + K, U'First (2) + J) *
                 L (L'First (1) + I, L'First (2) + K);
            end loop;
            U (U'First (1) + I, U'First (2) + J) :=
              A2 (A2'First (1) + I, A2'First (2) + J) - S;
         end loop;
         for I in J + 1 .. Order - 1 loop
            S := 0.0;
            for K in 0 .. J loop
               S := S + U (U'First (1) + K, U'First (2) + J) *
                 L (L'First (1) + I, L'First (2) + K);
            end loop;
            L (L'First (1) + I, L'First (2) + J) :=
              (A2 (A2'First (1) + I, A2'First (2) + J) - S) /
              U (U'First (1) + J, U'First (2) + J);
         end loop;
      end loop;
   end Decompose;

end Decomposition;
