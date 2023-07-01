import math, algorithm

type

  Point = tuple[x, y: float]
  Pair = tuple[p1, p2: Point]
  Result = tuple[minDist: float; minPoints: Pair]

#---------------------------------------------------------------------------------------------------

template sqr(x: float): float = x * x

#---------------------------------------------------------------------------------------------------

func dist(point1, point2: Point): float =
  sqrt(sqr(point2.x - point1.x) + sqr(point2.y - point1.y))

#---------------------------------------------------------------------------------------------------

func bruteForceClosestPair*(points: openArray[Point]): Result =

  doAssert(points.len >= 2, "At least two points required.")

  result.minDist = Inf
  for i in 0..<points.high:
    for j in (i + 1)..points.high:
      let d = dist(points[i], points[j])
      if  d < result.minDist:
        result = (d, (points[i], points[j]))

#---------------------------------------------------------------------------------------------------

func closestPair(xP, yP: openArray[Point]): Result =
  ## Recursive function which takes two open arrays as arguments: the first
  ## sorted by increasing values of x, the second sorted by increasing values of y.

  if xP.len <= 3:
    return xP.bruteForceClosestPair()

  let m = xP.high div 2
  let xL = xP[0..m]
  let xR = xP[(m + 1)..^1]

  let xm = xP[m].x
  var yL, yR: seq[Point]
  for p in yP:
    if p.x <= xm: yL.add(p)
    else: yR.add(p)

  let (dL, pairL) = closestPair(xL, yL)
  let (dR, pairR) = closestPair(xR, yR)
  let (dMin, pairMin) = if dL < dR: (dL, pairL) else: (dR, pairR)

  var yS: seq[Point]
  for p in yP:
    if abs(xm - p.x) < dmin: yS.add(p)

  result = (dMin, pairMin)
  for i in 0..<yS.high:
    var k = i + 1
    while k < yS.len and ys[k].y - yS[i].y < dMin:
      let d = dist(yS[i], yS[k])
      if d < result.minDist:
        result = (d, (yS[i], yS[k]))
      inc k

#---------------------------------------------------------------------------------------------------

func closestPair*(points: openArray[Point]): Result =

  let xP = points.sortedByIt(it.x)
  let yP = points.sortedByIt(it.y)
  doAssert(points.len >= 2, "At least two points required.")

  result = closestPair(xP, yP)

#———————————————————————————————————————————————————————————————————————————————————————————————————

import random, times, strformat

randomize()

const N = 50_000
const Max = 10_000.0
var points: array[N, Point]
for pt in points.mitems: pt = (rand(Max), rand(Max))

echo "Sample contains ", N, " random points."
echo ""

let t0 = getTime()
echo "Brute force algorithm:"
echo points.bruteForceClosestPair()
let t1 = getTime()
echo "Optimized algorithm:"
echo points.closestPair()
let t2 = getTime()

echo ""
echo fmt"Execution time for brute force algorithm: {(t1 - t0).inMilliseconds:>4} ms"
echo fmt"Execution time for optimized algorithm:   {(t2 - t1).inMilliseconds:>4} ms"
