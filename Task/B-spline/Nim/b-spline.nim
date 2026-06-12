import std/[math, strformat]
import cairo

type
  Point = tuple[x, y: float]
  BSpline = object
    controlPoints: seq[Point]
    n, k: int
    t: seq[float]


proc initBSpline(controlPoints: openArray[Point]; k: int): BSpline =
  result.controlPoints = @controlPoints
  result.n = controlPoints.high
  result.k = k
  for i in 0..(result.n + k):
    result.t.add (i + 1).toFloat


proc helper(bs: BSpline; i, k: int; x: float): float =
  if bs.t[i + k] != bs.t[i]:
    return (x - bs.t[i]) / (bs.t[i + k] - bs.t[i])


proc calculate(bs: BSpline; i, k: int; x: float): float =
  result = if k == 1:
             if bs.t[i] <= x and x < bs.t[i + 1]: 1
             else: 0
  else:
    bs.helper(i, k - 1, x) * bs.calculate(i, k - 1, x) +
    (1 - bs.helper(i + 1, k - 1, x)) * bs.calculate(i + 1, k - 1, x)


proc plot(bs: BSpline) =
  if bs.k > bs.n or bs.k < 1:
    quit &"k (= {bs.k}) can't be more than {bs.n} or less than 1.", QuitFailure

  var lastx, lasty: float
  var firstPoint = true

  let surface = imageSurfaceCreate(FormatRgb24, 400, 400)
  let context = surface.create()
  context.setSourceRgb(0.0, 0.0, 0.0)
  context.paint()

  # Draw control points.
  context.setSourceRgb(1.0, 0.0, 0.0)
  for cp in bs.controlPoints:
    context.arc(cp.x, cp.y, 3, 0, TAU)
    context.stroke()

  # Calculate and draw B-spline points.
  context.setSourceRgb(1.0, 1.0, 1.0)
  var x = bs.t[bs.k - 1]
  while x <= bs.t[bs.n]:
    var sumx, sumy = 0.0
    for i, cp in bs.controlPoints:
      let f = bs.calculate(i, bs.k, x)
      sumx += f * cp.x
      sumy += f * cp.y
    if firstPoint:
      lastx = sumx
      lasty = sumy
      firstPoint = false
    else:
      context.moveTo(lastx, lasty)
      context.lineTo(sumx, sumy)
      context.stroke()
      lastx = sumx
      lasty = sumy
    x += 0.1

  if surface.writeToPng("bspline.png") != StatusSuccess:
    quit "Error while saving file", QuitFailure
  surface.destroy()


const ControlPoints = [Point (171.0, 171.0), (185.0, 111.0),
                             (202.0, 109.0), (202.0, 189.0),
                             (328.0, 160.0), (208.0, 254.0),
                             (241.0, 330.0), (164.0, 252.0),
                             ( 69.0, 278.0), (139.0, 208.0),
                             ( 72.0, 148.0), (168.0, 172.0)]

let bspline = initBSpline(ControlPoints, 4)
bspline.plot()
