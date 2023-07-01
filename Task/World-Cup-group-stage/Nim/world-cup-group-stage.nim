import algorithm, sequtils, strutils
import itertools

const Scoring = [0, 1, 3]

var histo: array[4, array[10, int]]

for results in product([0, 1, 2], repeat = 6):
  var s: array[4, int]
  for (r, g) in zip(results, toSeq(combinations([0, 1, 2, 3], 2))):
    s[g[0]] += Scoring[r]
    s[g[1]] += Scoring[2 - r]
  for i, v in sorted(s):
    inc histo[i][v]

for x in reversed(histo):
  echo x.mapIt(($it).align(3)).join(" ")
