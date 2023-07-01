import std/[math, strformat, strutils]

type Vector = tuple[x, y: int]

func `+`(a, b: Vector): Vector =
  ## Return the sum of two vectors.
  (a.x + b.x, a.y + b.y)

func isqrt(n: int): int =
  ## Return the integer square root of "n".
  int(sqrt(n.toFloat))


proc babylonianSpiral(nsteps: int): seq[Vector] =
  ## Get the points for each step along a Babylonia spiral of `nsteps` steps.
  ## Origin is at (0, 0) with first step one unit in the positive direction along
  ## the vertical (y) axis. The other points are selected to have integer x and y
  ## coordinates, progressively concatenating the next longest vector with integer
  ## x and y coordinates on the grid. The direction change of the  new vector is
  ## chosen to be nonzero and clockwise in a direction that minimizes the change
  ## in direction from the previous vector.

  var xyDeltas: seq[Vector] = @[(0, 0), (0, 1)]
  var δsquared = 1
  for _ in 0..nsteps - 3:
    let (x, y) = xyDeltas[^1]
    let θ = arctan2(y.toFloat, x.toFloat)
    var candidates: seq[Vector]
    while candidates.len == 0:
      inc δsquared, 1
      for i in 0..<nsteps:
        let a = i * i
        if a > δsquared div 2:
          break
        for j in countdown(isqrt(δsquared) + 1, 1):
          let b = j * j
          if a + b < δsquared:
            break
          if a + b == δsquared:
            candidates.add [(i, j), (-i, j), (i, -j), (-i, -j), (j, i), (-j, i), (j, -i), (-j, -i)]
      var p: Vector
      var minVal = TAU
      for candidate in candidates:
        let val = floorMod(θ - arctan2(candidate.y.toFloat, candidate.x.toFloat), TAU)
        if val < minVal:
          minVal = val
          p = candidate
      xyDeltas.add p

  result = cumsummed(xyDeltas)

let points10000 = babylonianSpiral(10_000)


### Task ###
echo "The first 40 Babylonian spiral points are:"
for i, p in points10000[0..39]:
  stdout.write alignLeft(&"({p.x}, {p.y})", 10)
  stdout.write if (i + 1) mod 10 == 0: "\n" else: ""


### Stretch task ###

import gnuplot

var x, y: seq[float]
for p in points10000:
  x.add p.x.toFloat
  y.add p.y.toFloat

withGnuPlot:
  cmd "set size ratio -1"
  plot(x, y, "Babylonian spiral", "with lines lc black lw 1")
  png("babylonian_spiral.png")
