function a296712(): sequence of integer;
begin
  foreach var n in 1.step do
    if n.ToString
        .Pairwise((x, y) -> (if x > y then 1 else if x < y then -1 else 0))
        .Sum = 0 then
      yield n;
end;

begin
  println('The first 200 numbers are:');
  a296712.Take(200).Print;
  println;
  println;
  println('The 10,000,000th number is:');
  a296712.ElementAt(10_000_000 - 1).Println;
end.
