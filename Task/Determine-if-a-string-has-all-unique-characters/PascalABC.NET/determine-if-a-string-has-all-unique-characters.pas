##
var input := |'', '.', 'abcABC', 'XYZ ZYX', '1234567890ABCDEFGHIJKLMN0PQRSTUVWXYZ'|;
foreach var s in input do
  Writeln('''', s, '''', ' (Length ', s.Length, ') ',
     String.Join(', ',
     s.Select((c, i) -> (c, i))
     .GroupBy(t -> t[0])
     .Where(g -> g.Count() > 1)
     .Select(g -> '''' + g.Key + '''(0X' + Ord(g.key).ToString('x') + ') [' +
        String.Join(', ', g.Select(t -> t[1])) + ']')
     .DefaultIfEmpty('All characters are unique.')));
