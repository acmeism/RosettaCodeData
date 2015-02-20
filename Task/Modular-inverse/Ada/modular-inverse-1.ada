package Mod_Inv is

   procedure X_GCD(A, B: in Natural; D, X, Y: out Integer);
      -- the Extended Euclidean Algorithm
      -- finds (D, X, Y) with D = GCD(A, B) = A*X + B*Y

   function Inverse(A, M: Integer) return Integer;
      -- computes the multiplicative inverse Inv_A of A mod M, using X_GCD
      -- raises Constraint_Error if Inv_A does not exist

end Mod_Inv;
