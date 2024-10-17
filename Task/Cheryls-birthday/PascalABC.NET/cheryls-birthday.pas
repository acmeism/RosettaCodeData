##
var dates := HSet(('May', 15), ('May', 16), ('May', 19), ('June', 17),
                 ('June', 18), ('July', 14), ('July', 16), ('August', 14),
                 ('August', 15), ('August', 17));

var uniqueMonths := dates.GroupBy(d -> d[1]).Where(g -> g.count = 1).Select(g -> g.First()[0]).ToHashSet;
dates.RemoveWhere(d -> uniqueMonths.Contains(d[0]));
println('After first Albert''s sentence:', dates);

dates.IntersectWith(dates.GroupBy(d -> d[1]).Where(g -> g.Count() = 1).Select(g -> g.First()));
println('After Bernard''s sentence:', dates);

dates.IntersectWith(dates.GroupBy(d -> d[0]).Where(g -> g.Count() = 1).Select(g -> g.First()));
println('After second Albert''s sentence:', dates);
