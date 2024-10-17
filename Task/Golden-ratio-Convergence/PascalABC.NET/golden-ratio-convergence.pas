begin
  var phi := 1.0;
  var phiprev := 0.0;
  var n := 0;
  var err := 0.0;
  while True do
  begin
    n += 1;
    phi := 1 + 1/phi;
    err := Abs(phi - phiprev);
    if err <= 1e-5 then
      break;
    phiprev := phi;
  end;
  Println($'Result = {phi} after {n} iterations');
  Println($'The error is approximately = {phi - (1+sqrt(5)) / 2}');
end.
