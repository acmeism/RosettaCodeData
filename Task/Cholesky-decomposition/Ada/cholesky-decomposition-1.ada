with Ada.Numerics.Generic_Real_Arrays;
generic
   with package Matrix is new Ada.Numerics.Generic_Real_Arrays (<>);
package Decomposition is

   -- decompose a square matrix A by A = L * Transpose (L)
   procedure Decompose (A : Matrix.Real_Matrix; L : out Matrix.Real_Matrix);

end Decomposition;
