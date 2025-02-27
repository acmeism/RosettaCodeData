function mertens(max: integer): list<integer>;
begin
  result := (0..max).select( x -> 1).ToList;
  foreach var n in 2..max do
    foreach var k in 2..n do
      result[n] -= result[n div k];
end;

begin
  println('The first 99 Mertens numbers are:');
  foreach var m in mertens(99) index i do
    if i = 0 then write('   ')
    else write(m:3, if i mod 10 = 9 then #10 else '');

  var zeroes := mertens(1000).Where(x -> x = 0).Count;
  println('M(N) equals zero', zeroes, 'times.');

  var crosses := mertens(1000).Zip(mertens(1000).Skip(1), (x, y) -> (x <> 0) and (y = 0))
                              .Where(x -> x).Count;
  println('M(N) crosses zero', crosses, 'times.');
end.
