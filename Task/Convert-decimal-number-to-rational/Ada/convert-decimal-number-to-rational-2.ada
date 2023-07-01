procedure Real_To_Rational (R: Real;
                            Bound: Positive;
                            Nominator: out Integer;
                            Denominator: out  Positive) is
   Error: Real;
   Best: Positive := 1;
   Best_Error: Real := Real'Last;
begin
   if R = 0.0 then
      Nominator := 0;
      Denominator := 1;
      return;
   elsif R < 0.0 then
      Real_To_Rational(-R, Bound, Nominator, Denominator);
      Nominator := - Nominator;
      return;
   else
      for I in 1 .. Bound loop
         Error := abs(Real(I) * R - Real'Rounding(Real(I) * R));
         if Error < Best_Error then
            Best := I;
            Best_Error := Error;
         end if;
      end loop;
   end if;
   Denominator := Best;
   Nominator   := Integer(Real'Rounding(Real(Denominator) * R));

end Real_To_Rational;
