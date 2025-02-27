[cache]
function hof(n: integer): integer;
begin
  if n < 3 then result := 1
  else result := hof(hof(n - 1)) + hof(n - hof(n - 1))
end;

begin
  for var nmax := 1 to 19 do
  begin
    var amax := 0.0;
    for var n := 1 shl nmax to 1 shl (nmax + 1) do
      amax := max(amax, hof(n) / n);
    writeln('Maximum between 2^', nmax, ' and 2^', nmax + 1, ' was ', amax);
  end;

  var prize := 1 shl 20;
  repeat
    prize -= 1;
  until (hof(prize) / prize >= 0.55);
  println('Mallows'' number =', prize);
end.
