import tables, math, strutils, complex, random

proc random[T](a: openarray[T]): T =
  result = a[rand(low(a)..len(a))]

type Point = tuple[x, y: int]

var world = initCountTable[Point]()
var possiblePoints = newSeq[Point]()

for x in -15..15:
  for y in -15..15:
    if abs((x.float, y.float)) in 10.0..15.0:
      possiblePoints.add((x,y))

randomize()
for i in 0..100: world.inc possiblePoints.random

for x in -15..15:
  for y in -15..15:
    let key = (x, y)
    if key in world and world[key] > 0:
      stdout.write min(9, world[key])
    else:
      stdout.write ' '
  echo ""
