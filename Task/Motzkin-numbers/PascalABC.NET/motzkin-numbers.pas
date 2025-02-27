function IsPrime(n: int64): boolean;
begin
  if (n = 2) or (n = 3) then Result := true
  else if (n <= 1) or ((n mod 2) = 0) or ((n mod 3) = 0) then Result := false
  else
  begin
    var i := 5;
    Result := False;
    while i <= trunc(sqrt(n)) do
    begin
      if ((n mod i) = 0) or ((n mod (i + 2)) = 0) then exit;
      i += 6;
    end;
    Result := True;
  end;
end;

function mot(): sequence of biginteger;
begin
  var (a, b, n) := (0bi, 1bi, 1bi);
  repeat
    yield b div n;
    n += 1;
    (a, b) := (b, (3 * (n - 1) * n * a + (2 * n - 1) * n * b) div ((n + 1) * (n - 1)))
  until false;
end;

begin
  foreach var val in mot.Take(42) index i do
    writeln(i:2, val:20, if isprime(int64(val)) then ' is prime' else '');
end.
