function Factorial(N : Positive) return Positive is
   Result : Positive := 1;
begin
   if N > 1 then
      Result := N * Factorial(N - 1);
   end if;
   return Result;
end Factorial;
