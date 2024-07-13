function MyExp(x: real): real;
const eps = 1e-15;
begin
  var y := 1.0;
  var s := y;
  var i := 1;
  while y > eps do
  begin
    y *= x / i;
    s += y;
    i += 1;
  end;
  Result := s;
end;

begin
  Println(MyExp(1));
  Println(Exp(1));
end.
