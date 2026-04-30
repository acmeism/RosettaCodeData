with Ada.Numerics.Generic_Real_Arrays;
generic
   with package Matrix is new Ada.Numerics.Generic_Real_Arrays (<>);
package Decomposition is

   -- decompose a square matrix A by PA = LU
   procedure Decompose (A : Matrix.Real_Matrix; P, L, U : out Matrix.Real_Matrix);

end Decomposition;
