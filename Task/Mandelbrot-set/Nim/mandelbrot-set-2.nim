import math, complex, lenientops
import imageman

const
  W = 800
  H = 600
  Zoom = 0.5
  MoveX = -0.5
  MoveY = 0.0
  MaxIter = 30

func hsvToRgb(h, s, v: float): array[3, float] =
  let c = v * s
  let x = c * (1 - abs(((h / 60) mod 2) - 1))
  let m = v - c
  let (r, g, b) = if h < 60: (c, x, 0.0)
                  elif h < 120: (x, c, 0.0)
                  elif h < 180: (0.0, c, x)
                  elif h < 240: (0.0, x, c)
                  elif x < 300: (x, 0.0, c)
                  else: (c, 0.0, x)
  result = [r + m, g + m, b + m]


var img = initImage[ColorRGBF64](W, H)
for x in 1..W:
  for y in 1..H:
    var i = MaxIter - 1
    let c = complex((2 * x - W) / (W * Zoom) + MoveX, (2 * y - H) / (H * Zoom) + MoveY)
    var z = c
    while abs(z) < 2 and i > 0:
      z = z * z + c
      dec i
    let color = hsvToRgb(i / MaxIter * 360, 1, i / MaxIter)
    img[x - 1, y - 1] = ColorRGBF64(color)

img.savePNG("mandelbrot.png", compression = 9)
