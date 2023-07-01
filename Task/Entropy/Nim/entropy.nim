import tables, math

proc entropy(s: string): float =
  var t = initCountTable[char]()
  for c in s: t.inc(c)
  for x in t.values: result -= x/s.len * log2(x/s.len)

echo entropy("1223334444")
