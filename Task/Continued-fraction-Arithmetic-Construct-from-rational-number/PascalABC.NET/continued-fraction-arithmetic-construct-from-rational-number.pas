function r2cf(n1, n2: integer): sequence of integer;
begin
  while n2 <> 0 do
  begin
    yield n1 div n2;
    n1 := n1 mod n2;
    swap(n1, n2);
  end;
end;

begin
  foreach var pair in |(1, 2), (3, 1), (23, 8), (13, 11), (22, 7), (-151, 77)| do
    println(pair, ' -> ', r2cf(pair[0], pair[1]));

  println;
  foreach var pair in |(14142, 10000), (141421, 100000), (1414214, 1000000), (14142136, 10000000)| do
    println(pair, ' -> ', r2cf(pair[0], pair[1]));

  println;
  foreach var pair in |(31, 10), (314, 100), (3142, 1000), (31428, 10000), (314285, 100000),
  (3142857, 1000000), (31428571, 10000000), (314285714, 100000000)| do
    println(pair, ' -> ', r2cf(pair[0], pair[1]));
end.
