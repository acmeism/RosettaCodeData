function modifier(x: real) := if x < 0.5 then 2 * (0.5 - x) else 2 * (x - 0.5);

function modrand(modifier: real-> real): sequence of real;
begin
  repeat
    var r := Random;
    if Random < modifier(r) then yield r;
  until false;
end;

begin
  var data := modrand(modifier).Take(100_000);
  var bins := data.Select(x -> (20 * x).Floor)
                  .Sorted
                  .GroupBy(n -> n)
                  .Select(g -> g.Count);

  writeln('Bin Counts  Histogram');
  foreach var counts in bins index i do
    writeln(i / 20:2:2, counts:6, ': ', '■' * (counts div 125));
end.
