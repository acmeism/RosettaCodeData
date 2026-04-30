function Factorial (N : Positive) return Positive is
   Result : Positive := N;
   Counter : Natural := N - 1;
begin
   for I in reverse 1..Counter loop
      Result := Result * I;
   end loop;
   return Result;
end Factorial;
