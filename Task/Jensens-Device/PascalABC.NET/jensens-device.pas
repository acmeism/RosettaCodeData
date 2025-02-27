function Sum(var i: integer; lo, hi: integer; term: ()-> real): real;
begin
  i := lo;
  while i <= hi do
  begin
    result += term();
    i += 1;
  end;
end;

begin
  var i := 0;
  Writeln(Sum(i, 1, 100, () -> 1.0 / i));
end.
