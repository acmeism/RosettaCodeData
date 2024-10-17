function FibonacciI(N: Word): UInt64;
var
  Last, New: UInt64;
  I: Word;
begin
  if N < 2 then
    Result := N
  else begin
    Last := 0;
    Result := 1;
    for I := 2 to N do
    begin
      New := Last + Result;
      Last := Result;
      Result := New;
    end;
  end;
end;
