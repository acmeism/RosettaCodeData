function Fibonacci(N: Word): UInt64;
begin
  if N < 2 then
    Result := N
  else
   Result := Fibonacci(N - 1) + Fibonacci(N - 2);
end;
