##
function levenshteinDistance(s1, s2: string): integer;
begin
  if s1.Length > s2.Length then swap(s1, s2);

  var distances := Range(0, s1.Length).ToList;

  foreach var c2 in s2 index i2 do
  begin
    var newDistances := Lst(i2 + 1);
    foreach var c1 in s1 index i1 do
      if c1 = c2 then
        newDistances.Add(distances[i1])
      else
        newDistances.Add(1 + Min(distances[i1], distances[i1 + 1], newDistances[^1]));

    distances := newDistances;
  end;
  result := distances[^1];
end;

levenshteinDistance('kitten', 'sitting').println;
levenshteinDistance('rosettacode', 'raisethysword').println;
