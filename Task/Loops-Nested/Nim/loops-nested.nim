import random, strutils

const ArrSize = 10

var a: array[ArrSize, array[ArrSize, int]]
var s = ""

randomize()   # Different results each time this runs.

# Initialize using loops on items rather than indexes.
for row in a.mitems:
  for item in row.mitems:
    item = rand(1..20)

block outer:
  # Loop using indexes.
  for i in 0..<ArrSize:
    for j in 0..<ArrSize:
      if a[i][j] < 10: s.add(' ')
      addf(s, "$#", $a[i][j])
      if a[i][j] == 20: break outer
      s.add(", ")
    s.add('\n')

echo s
