import math
import imageman

const
  Size = 600
  X0 = Size div 2
  Y0 = Size div 2
  Background = ColorRGBU [byte 0, 0, 0]
  Foreground = ColorRGBU [byte 255, 255, 255]


proc drawSuperEllipse(img: var Image; n: float; a, b: int) =

  var yList = newSeq[int](a + 1)
  for x in 0..a:
    let an = pow(a.toFloat, n)
    let bn = pow(b.toFloat, n)
    let xn = pow(x.toFloat, n)
    let t = max(bn - xn * bn / an, 0.0)   # Avoid negative values due to rounding errors.
    yList[x] = pow(t, 1/n).toInt

  var pos: seq[Point]
  for x in countdown(a, 0):
    pos.add (X0 + x, Y0 - yList[x])
  for x in 0..a:
    pos.add (X0 - x, Y0 - yList[x])
  for x in countdown(a, 0):
    pos.add (X0 - x, Y0 + yList[x])
  for x in 0..a:
    pos.add (X0 + x, Y0 + yList[x])
  img.drawPolyline(true, Foreground, pos)


var image = initImage[ColorRGBU](Size, Size)
image.fill(Background)
image.drawSuperEllipse(2.5, 200, 200)
image.savePNG("super_ellipse.png", compression = 9)
