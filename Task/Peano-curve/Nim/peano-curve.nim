import imageman

const Width = 81

proc peano(points: var seq[Point]; x, y, lg, i1, i2: int) =

  if lg == 1:
    points.add ((Width - x) * 10, (Width - y) * 10)
    return

  let lg = lg div 3
  points.peano(x + 2 * i1 * lg, y + 2 * i1 * lg, lg, i1, i2)
  points.peano(x + (i1 - i2 + 1) * lg, y + (i1 + i2) * lg, lg, i1, 1 - i2)
  points.peano(x + lg, y + lg, lg, i1, 1 - i2)
  points.peano(x + (i1 + i2) * lg, y + (i1 - i2 + 1) * lg, lg, 1 - i1, 1 - i2)
  points.peano(x + 2 * i2 * lg, y + 2 * (1-i2) * lg, lg, i1, i2)
  points.peano(x + (1 + i2 - i1) * lg, y + (2 - i1 - i2) * lg, lg, i1, i2)
  points.peano(x + 2 * (1 - i1) * lg, y + 2 * (1 - i1) * lg, lg, i1, i2)
  points.peano(x + (2 - i1 - i2) * lg, y + (1 + i2 - i1) * lg, lg, 1 - i1, i2)
  points.peano(x + 2 * (1 - i2) * lg, y + 2 * i2 * lg, lg, 1 - i1, i2)


var points: seq[Point]
points.peano(0, 0, Width, 0, 0)
var image = initImage[ColorRGBU](820, 820)
let color = ColorRGBU([byte 255, 255, 0])
for i in 1..points.high:
  image.drawLine(points[i - 1], points[i], color)
image.savePNG("peano.png", compression = 9)
