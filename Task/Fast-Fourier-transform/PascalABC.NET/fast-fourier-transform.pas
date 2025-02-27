function fft(x: array of complex): array of complex;
begin
  var n := x.length;
  if n = 0 then exit;

  setlength(result, n);

  if n = 1 then
  begin
    result[0] := x[0];
    exit;
  end;

  var evens := x.Where((x, i) -> i mod 2 = 0).ToArray;
  var odds := x.Where((x, i) -> i mod 2 = 1).ToArray;
  var (even, odd) := (fft(evens), fft(odds));

  var halfn := n div 2;

  for var k := 0 to halfn - 1 do
  begin
    var a := exp(new Complex(0.0, -2 * Pi * k / n)) * odd[k];
    result[k] := even[k] + a;
    result[k + halfn] := even[k] - a;
  end;
end;

begin
  var test := |1.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, 0.0|;
  foreach var x in fft(test.select(x -> new Complex(x, 0)).ToArray) do
    println(x)
end.
