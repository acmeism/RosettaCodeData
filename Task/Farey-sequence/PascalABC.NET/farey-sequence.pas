function Generate(n: integer): list<(integer, integer)>;
begin
  var fractions := new list<(integer, integer)>;
  result := new list<(integer, integer)>;
  for var den := 1 to n do
    for var num := 0 to den do fractions.Add((num, den));
  fractions := fractions.OrderBy(f -> f[0] / f[1]).ToList;

  result.Add(fractions[0]);
  for var i := 0 to fractions.Count - 2 do
    if fractions[i][0] * fractions[i + 1][1] <> fractions[i][1] * fractions[i + 1][0] then
      result.add(fractions[i + 1]);
end;

begin
  for var i := 1 to 11 do
    writeln('F', i, ': ', Generate(i).Select(f -> f[0].ToString + '/' + f[1].tostring));
  for var i := 100 to 1000 step 100 do
    writeln('F', i, ' has ', Generate(i).Count, ' terms.');
end.
