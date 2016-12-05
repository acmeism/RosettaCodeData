import tables, os

var t = initCountTable[char]()
var f = open(paramStr(1))
for l in f.lines:
  for c in l:
    t.inc(c)
echo t
