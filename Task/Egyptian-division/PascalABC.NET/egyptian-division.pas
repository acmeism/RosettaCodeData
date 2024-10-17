function egyptian_divmod(dividend, divisor: integer): (integer, integer);
begin
  assert(divisor <> 0);
  var pwrs := |1|;
  var dbls := |divisor|;
  while dbls.Last <= dividend do
  begin
    pwrs := pwrs + |pwrs.Last * 2|;
    dbls := dbls + |pwrs.last * divisor|;
  end;
  var (ans, accum) := (0, 0);
  for var i := pwrs.Length - 1 to 0 step -1 do
    if accum + dbls[i] <= dividend then
    begin
      accum += dbls[i];
      ans += pwrs[i];
    end;
  result :=  (ans, abs(accum - dividend));
end;

begin
  var (dividend, divisor) := (580, 34);
  var (quotient, remainder) := egyptian_divmod(dividend, divisor);
  println(dividend, 'divided by', divisor, 'using the Egyption method is', quotient, 'remainder', remainder);
end.
