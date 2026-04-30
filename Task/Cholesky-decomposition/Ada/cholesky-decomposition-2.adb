with Ada.Numerics.Generic_Elementary_Functions;

package body Decomposition is
   package Math is new Ada.Numerics.Generic_Elementary_Functions
     (Matrix.Real);

   procedure Decompose (A : Matrix.Real_Matrix; L : out Matrix.Real_Matrix) is
      use type Matrix.Real_Matrix, Matrix.Real;
      Order : constant Positive := A'Length (1);
      S     : Matrix.Real;
   begin
      L := (others => (others => 0.0));
      for I in 0 .. Order - 1 loop
         for K in 0 .. I loop
            S := 0.0;
            for J in 0 .. K - 1 loop
               S := S +
                 L (L'First (1) + I, L'First (2) + J) *
                 L (L'First (1) + K, L'First (2) + J);
            end loop;
            -- diagonals
            if K = I then
               L (L'First (1) + K, L'First (2) + K) :=
                 Math.Sqrt (A (A'First (1) + K, A'First (2) + K) - S);
            else
               L (L'First (1) + I, L'First (2) + K) :=
                 1.0 / L (L'First (1) + K, L'First (2) + K) *
                 (A (A'First (1) + I, A'First (2) + K) - S);
            end if;
         end loop;
      end loop;
   end Decompose;
end Decomposition;
