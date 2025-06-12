function solvePell(n: integer): (biginteger, biginteger);
begin
  var x: biginteger := n.sqrt.floor;
  var (y, z, r) := (x, 1bi, x shl 1);
  var (e1, e2) := (1bi, 0bi);
  var (f1, f2) := (0bi, 1bi);

  repeat
    y := r * z - y;
    z := (n - y * y) div z;
    r := (x + y) div z;

    (e1, e2) := (e2, e1 + e2 * r);
    (f1, f2) := (f2, f1 + f2 * r);

    var (a, b) := (f2 * x + e2, f2);
    if a * a - n * b * b = 1 then
    begin
      result := (a, b);
      exit
    end;
  until false;
end;

begin
  foreach var n in |61, 109, 181, 277| do
  begin
    var (x, y) := solvePell(n);
    writeln('x² - ', n:3, ' * y² = 1 for (x, y) = (', x:21, ',',y:20, ')');
  end;
end.
