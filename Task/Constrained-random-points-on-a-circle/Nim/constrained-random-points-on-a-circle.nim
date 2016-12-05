import tables, math, strutils, complex
randomize()

proc random[T](a: openarray[T]): T =
  result = a[random(low(a)..len(a))]

type Point = tuple[x, y: int]

var world = initCountTable[Point]()

var possiblePoints = newSeq[Point]()
for x in -15..15:
  for y in -15..15:
    if abs((x.float, y.float)) in 10.0..15.0:
      possiblePoints.add((x,y))

for i in 0..100: world.inc possiblePoints.random

for x in -15..15:
  for y in -15..15:
    if world[(x,y)] > 0:
      stdout.write min(9, world[(x,y)])
    else:
      stdout.write ' '
  echo ""
