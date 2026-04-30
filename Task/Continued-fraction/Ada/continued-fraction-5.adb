function Continued_Fraction_Ada95 (Steps : in Natural) return Scalar is
   function A (N : in Natural)  return Scalar is
   begin
      return Scalar (Natural'(A (N)));
   end A;

   function B (N : in Positive) return Scalar is
   begin
      return Scalar (Natural'(B (N)));
   end B;

   Fraction : Scalar := 0.0;
begin
   for N in reverse Natural range 1 .. Steps loop
      Fraction := B (N) / (A (N) + Fraction);
   end loop;
   return A (0) + Fraction;
end Continued_Fraction_Ada95;
