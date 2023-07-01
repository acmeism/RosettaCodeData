import lenientops
import imageman

const
  W = 800
  H = 600
  Zoom = 1
  MaxIter = 255
  MoveX = 0
  MoveY = 0
  Cx = -0.7
  Cy = 0.27015

var colors: array[256, ColorRGBU]
for n in byte.low..byte.high:
  colors[n] = ColorRGBU [n shr 5 * 36, (n shr 3 and 7) * 36, (n and 3) * 85]

var image = initImage[ColorRGBU](W, H)

for x in 0..<W:
  for y in 0..<H:
    var zx = 1.5 * (x - W / 2) / (0.5 * Zoom * W) + MoveX
    var zy = 1.0 * (y - H / 2) / (0.5 * Zoom * H) + MoveY
    var i = MaxIter
    while zx * zx + zy * zy < 4 and i > 1:
      (zy, zx) = (2.0 * zx * zy + Cy, zx * zx - zy * zy + Cx)
      dec i
    image[x, y] = colors[i]

# Save into a PNG file.
image.savePNG("julia.png", compression = 9)
