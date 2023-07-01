import math
import imageman

template ipart(x: float): float = floor(x)
template fpart(x: float): float = x - ipart(x)
template rfpart(x: float): float = 1 - fpart(x)

const
  BG = ColorRGBF64([0.0, 0.0, 0.0])
  FG = ColorRGBF64([1.0, 1.0, 1.0])

func plot(img: var Image; x, y: int; c: float) =
  ## Draw a point with brigthness c.
  let d = 1 - c
  img[x, y] = ColorRGBF64([BG.r * d + FG.r * c, BG.g * d + FG.g * c, BG.b * d + FG.b * c])


func drawLine(img: var Image; x0, y0, x1, y1: float) =
  ## Draw an anti-aliased line from (x0, y0) to (x1, y1).

  var (x0, y0, x1, y1) = (x0, y0, x1, y1)
  let steep = abs(y1 - y0) > abs(x1 - x0)
  if steep:
    swap x0, y0
    swap x1, y1
  if x0 > x1:
    swap x0, x1
    swap y0, y1

  let dx = x1 - x0
  let dy = y1 - y0
  var gradient = dy / dx
  if dx == 0:
    gradient = 1

  # Handle first endpoint.
  var xend = round(x0)
  var yend = y0 + gradient * (xend - x0)
  var xgap = rfpart(x0 + 0.5)
  let xpxl1 = xend.toInt
  let ypxl1 = yend.toInt
  if steep:
    img.plot(ypxl1, xpxl1, rfpart(yend) * xgap)
    img.plot(ypxl1 + 1, xpxl1, fpart(yend) * xgap)
  else:
    img.plot(xpxl1, ypxl1, rfpart(yend) * xgap)
    img.plot(xpxl1, ypxl1 + 1, fpart(yend) * xgap)
  var intery = yend + gradient    # First y-intersection for the main loop.

  # Handle second endpoint.
  xend = round(x1)
  yend = y1 + gradient * (xend - x1)
  xgap = fpart(x1 + 0.5)
  let xpxl2 = xend.toInt
  let ypxl2 = yend.toInt
  if steep:
    img.plot(ypxl2, xpxl2, rfpart(yend) * xgap)
    img.plot(ypxl2 + 1, xpxl2, fpart(yend) * xgap)
  else:
    img.plot(xpxl2, ypxl2, rfpart(yend) * xgap)
    img.plot(xpxl2, ypxl2 + 1, fpart(yend) * xgap)

  # Main loop.
  if steep:
    for x in (xpxl1 + 1)..(xpxl2 - 1):
      img.plot(intery.int, x, rfpart(intery))
      img.plot(intery.int + 1, x, fpart(intery))
      intery += gradient
  else:
    for x in (xpxl1 + 1)..(xpxl2 - 1):
      img.plot(x, intery.int, rfpart(intery))
      img.plot(x, intery.int + 1, fpart(intery))
      intery += gradient


when isMainModule:
  var img = initImage[ColorRGBF64](800, 800)
  img.fill(BG)
  for x1 in countup(100, 700, 60):
    img.drawLine(400, 700, x1.toFloat, 100)
  img.savePNG("xiaoling_wu.png", compression = 9)
