type
  Metal = (platinum, golden, silver, bronze, copper, nickel, aluminium, iron, tin, lead);

function seq(b: integer): sequence of biginteger;
begin
  // Yield the successive terms if a “Lucas” sequence.
  // The first two terms are ignored.
  var x := 1bi;
  var y := 1bi;
  while true do
  begin
    x += b * y;
    Swap(x, y);
    yield y;
  end;
end;

function plural(n: integer) := if n >= 2 then 's' else '';

procedure computeRatio(b: integer; digits: integer);
begin
  // Compute the ratio for the given "n" with the required number of digits.

  var M := Power(10bi, digits);

  var niter := 0;     // Number of iterations.
  var prevN := 1bi;   // Previous value of "n".
  var ratio := M  ;   // Current value of ratio.

  foreach var n in seq(b) do
  begin
    inc(niter);
    var nextRatio := n * M div prevN;
    if nextRatio = ratio then break;
    prevN := n;
    ratio := nextRatio;
  end;

  var str := ratio.ToString;
  insert('.', str, 2);
  Writeln('Value to ', digits, ' decimal places after ', niter, ' iteration', plural(niter), ': ',str);
end;

begin
  foreach var b in 0..9 do
  begin
    Writeln('“Lucas” sequence for ', Metal(b), ' ratio where b = ', b, ':');
    Write('First 15 elements: 1 1 ');
    var count := 2;
    foreach var n in seq(b) do
    begin
      Write(' ', n);
      Inc(count);
      if count = 15 then break
    end;
    println;
    computeRatio(b, 32);
    Println;
  end;

  Println('Golden ratio where b = 1:');
  computeRatio(1, 256);
end.
