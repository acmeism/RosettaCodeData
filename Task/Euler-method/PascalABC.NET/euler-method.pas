procedure euler(f: (real) -> real; y0, a, b, h: real);
begin
  var (t, y) := (a, y0);
  write(' Step', h:3, ':');
  while t <= b do
  begin
    if integer(t) mod 10 = 0 then write(y:8:3);
    t += h;
    y += h * f(y);
  end;
  writeln;
end;

procedure analytic();
begin
  write('    Time:');
  for var t := 0 to 100 step 10 do write(t:8);
  writeln;
  write('Analytic:');
  for var t := 0 to 100 step 10 do
    write(20.0 + 80.0 * exp(-0.07 * t):8:3);
  println();
end;

function newtoncooling(temp: real): real := -0.07 * (temp - 20);

begin
analytic;
foreach var i in |2, 5, 10| do
  euler(newtoncooling, 100.0, 0.0, 100.0, i)
end.
