function Factors(N: BigInteger): List<BigInteger>;
begin
  var lst := new List<BigInteger>;
  if N = 1 then
    lst.Add(N);
  var i := 2bi;
  while i * i <= N do
  begin
    while N mod i = 0 do
    begin
      lst.Add(i);
      N := N div i;
    end;
    i += 1;
  end;
  if N >= 2 then
    lst.Add(N);
  Result := lst;
end;
