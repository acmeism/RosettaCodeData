function LongTimeCalc(n: integer): real;
begin
  var sum := 0.0;
  for var i:=1 to n do
    for var j := 1 to n do
      sum += 1/i/j;
  Result := sum;
end;

begin
  MillisecondsDelta;
  LongTimeCalc(10000).Println;
  MillisecondsDelta.Println;
end.
