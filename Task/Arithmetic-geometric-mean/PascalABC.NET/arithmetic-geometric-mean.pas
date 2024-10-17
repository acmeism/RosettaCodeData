function agm(a,g: real; eps: real := 1e-10): real;
begin
  var an := (a + g) / 2;
  var gn := Sqrt(a * g);
  while Abs(an - gn) > eps do
    (an,gn) := ((an + gn) / 2, Sqrt(an * gn));
  Result := an;
end;

begin
  Print(agm(1, 1 / Sqrt(2)))
end.
