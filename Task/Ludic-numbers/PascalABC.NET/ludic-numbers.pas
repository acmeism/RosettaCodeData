function ludic(): sequence of integer;
begin
  yield 1;
  var ludics := new List<integer>;
  while True do
  begin
    var k := 0;
    foreach var j in ludics[::-1] do
      k := (k * j) div (j - 1) + 1;
    ludics.Add(k + 2);
    yield k + 2
  end;
end;

function triplets(): sequence of (integer, integer, integer);
begin
  var (a, b, c, d) := (0, 0, 0, 0);
  foreach var k in ludic do
  begin
    if (k - 4 in [b, c, d]) and (k - 6 in [a, b, c]) then
      yield (k - 6, k - 4, k);
    (a, b, c, d) := (b, c, d, k);
  end;
end;

begin
  writeln('First 25 ludic numbers:');
  ludic.Take(25).Println;

  write(#10, 'Ludic numbers below 1000: ');
  ludic.TakeWhile(x -> x <= 1000).Count.Println;

  writeln(#10, 'Ludic numbers 2000 to 2005: ');
  ludic.Skip(2000 - 1).Take(6).Println;

  writeln(#10, 'all triplets of ludic numbers < 250: ');
  triplets.TakeWhile(x -> x[2] < 250).Println;
end.
