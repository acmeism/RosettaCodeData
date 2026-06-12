import math
import imageman

const
  Size = 600
  Background = ColorRGBU [byte 0, 0, 0]
  Foreground = ColorRGBU [byte 0, 255, 0]
  C = (sqrt(5.0) + 1) / 2
  NumberOfSeeds = 6000
  Fn = float(NumberOfSeeds)

var image = initImage[ColorRGBU](Size, Size)
image.fill(Background)

for i in 0..<NumberOfSeeds:
  let
    fi = float(i)
    r = pow(fi, C) / Fn
    angle = 2 * PI * C * fi
    x = toInt(r * sin(angle) + Size div 2)
    y = toInt(r * cos(angle) + Size div 2)
  image.drawCircle(x, y, toInt(8 * fi / Fn), Foreground)

image.savePNG("sunflower.png", compression = 9)
