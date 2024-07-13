function SumDigits(n, base: integer): integer;
begin
  var sum := 0;
  while n > 0 do
  begin
    sum += n mod base;
    n := n div base;
  end;
  Result := sum;
end;

begin
  Print(SumDigits(1, 10));
  Print(SumDigits(1234, 10));
  Print(SumDigits($FE, 16));
  Print(SumDigits($F0E, 16));
end.
