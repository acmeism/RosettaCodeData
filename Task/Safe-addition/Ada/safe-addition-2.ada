function "+" (A, B : Float) return Interval is
   Result : constant Float := A + B;
begin
   if Result < 0.0 then
      if Float'Machine_Rounds then
         return (Float'Adjacent (Result, Float'First), Float'Adjacent (Result, 0.0));
      else
         return (Float'Adjacent (Result, Float'First), Result);
      end if;
   elsif Result > 0.0 then
      if Float'Machine_Rounds then
         return (Float'Adjacent (Result, 0.0), Float'Adjacent (Result, Float'Last));
      else
         return (Result, Float'Adjacent (Result, Float'Last));
      end if;
   else -- Underflow
      return (Float'Adjacent (0.0, Float'First), Float'Adjacent (0.0, Float'Last));
   end if;
end "+";
