function ProperDivisorsProduct(n: int64): int64;
begin
  result := 1;
  var d := 2;
  repeat
    if n mod d = 0 then
    begin
      result *= d;
      var q := n div d;
      if q <> d then result *= q;
    end;
    d += 1;
  until d * d > n;
end;

function a111398(): sequence of int64;
begin
  foreach var n: int64 in 1.step do
    if n * n * n = ProperDivisorsProduct(n) then yield n;
end;

begin
  foreach var n in a111398.Take(50) index i do
    write(n:4, if (i + 1) mod 10 = 0 then #10 else '');
  writeln;
  foreach var n in |500, 5000, 50000| do
    writeln(n:5, ' ', a111398.ElementAt(n - 1));
end.
