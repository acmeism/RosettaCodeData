import math

const Sqrt3_2 = sqrt(3.0) / 2.0

type Point = tuple[x, y: float]


func sierpinskiArrowheadNext(points: seq[Point]): seq[Point] =
  result.setLen(3 * (points.len - 1) + 1)
  var j = 0
  for i in 0..<points.high:
    let (x0, y0) = points[i]
    let (x1, y1) = points[i + 1]
    let dx = x1 - x0
    result[j] = (x0, y0)
    if y0 == y1:
      let d = abs(dx * Sqrt3_2 / 2)
      result[j + 1] = (x0 + dx / 4, y0 - d)
      result[j + 2] = (x1 - dx / 4, y0 - d)
    elif y1 < y0:
      result[j + 1] = (x1, y0)
      result[j + 2] = (x1 + dx / 2, (y0 + y1) / 2)
    else:
      result[j + 1] = (x0 - dx / 2, (y0 + y1) / 2)
      result[j + 2] = (x0, y1)
    inc j, 3
  result[j] = points[^1]


proc writeSierpinskiArrowhead(outfile: File; size, iterations: int) =
  outfile.write "<svg xmlns='http://www.w3.org/2000/svg' width='", size, "' height='", size, "'>\n"
  outfile.write "<rect width='100%' height='100%' fill='white'/>\n"
  outfile.write "<path stroke-width='1' stroke='black' fill='none' d='"
  const Margin = 20.0
  let side = size.toFloat - 2 * Margin
  let x = Margin
  let y = 0.5 * size.toFloat + 0.5 * Sqrt3_2 * side
  var points = @[(x: x, y: y), (x: x + side, y: y)]
  for _ in 1..iterations:
    points = sierpinskiArrowheadNext(points)
  for i, point in points:
    outfile.write if i == 0: 'M' else: 'L', point.x, ',', point.y, '\n'
  outfile.write "'/>\n</svg>\n"


let outfile = open("sierpinski_arrowhead.svg", fmWrite)
outfile.writeSierpinskiArrowhead(600, 8)
outfile.close()
