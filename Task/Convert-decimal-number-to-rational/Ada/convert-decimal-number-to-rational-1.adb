generic
   type Real is digits <>;
procedure Real_To_Rational(R: Real;
                           Bound: Positive;
                           Nominator: out Integer;
                           Denominator: out Positive);
