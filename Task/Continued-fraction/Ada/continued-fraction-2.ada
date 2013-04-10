function Continued_Fraction (Steps : in Natural) return Scalar is
   function A (N : in Natural)  return Scalar is (Scalar (Natural'(A (N))));
   function B (N : in Positive) return Scalar is (Scalar (Natural'(B (N))));

   Fraction : Scalar := 0.0;
begin
   for N in reverse Natural range 1 .. Steps loop
      Fraction := B (N) / (A (N) + Fraction);
   end loop;
   return A (0) + Fraction;
end Continued_Fraction;
