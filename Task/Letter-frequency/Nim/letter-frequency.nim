import tables, os

var t = initCountTable[char]()
for l in paramStr(1).lines:
  for c in l:
    t.inc(c)
echo t
