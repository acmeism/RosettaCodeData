uses GraphWPF;

const colpick = (Colors.Red, Colors.Green, Colors.Blue);

function IsPrime(x: longword): boolean;
begin
  var i := 2;
  while (i * i <= x) and (x mod i <> 0) do
    i += 1;
  Result := i * i > x;
end;

function g(n: integer): integer;
begin
  assert((n > 2) and (n mod 2 = 0), '“n” must be even and greater than 2.');
  for var i := 2 to (n div 2)  do
    if isPrime(i) and isPrime(n - i) then
      result += 1;
end;

begin
  println('First 100 G numbers:');
  foreach var n in (2..101) index i do
  begin
    write(g( 2 * n):3);
    if (i + 1) mod 10 = 0 then writeln;
  end;
  println;
  println('G(1_000_000) =', g(1_000_000));

  setMathematicCoords(0, 4000, 0, false);
  foreach var x in range(4, 4002, 2) do
  begin
    fillcircle(x, g(x)*15, 10, colpick[(x div 2) mod 3]);
  end;
end.
