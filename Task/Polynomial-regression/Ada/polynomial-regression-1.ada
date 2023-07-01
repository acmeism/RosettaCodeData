with Ada.Numerics.Real_Arrays;  use Ada.Numerics.Real_Arrays;

function Fit (X, Y : Real_Vector; N : Positive) return Real_Vector is
   A : Real_Matrix (0..N, X'Range);  -- The plane
begin
   for I in A'Range (2) loop
      for J in A'Range (1) loop
         A (J, I) := X (I)**J;
      end loop;
   end loop;
   return Solve (A * Transpose (A), A * Y);
end Fit;
