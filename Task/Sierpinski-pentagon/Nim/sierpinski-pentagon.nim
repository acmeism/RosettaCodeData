import math
import imageman

const
  Red = ColorRGBU [byte 255, 0, 0]
  Green = ColorRGBU [byte 0, 255, 0]
  Blue = ColorRGBU [byte 0, 0, 255]
  Magenta = ColorRGBU [byte 255, 0, 255]
  Cyan = ColorRGBU [byte 0, 255, 255]
  Black = ColorRGBU [byte 0, 0, 0]

  (W, H) = (640, 640)
  Deg72 = degToRad(72.0)
  ScaleFactor = 1 / ( 2 + cos(Deg72) * 2)
  Palette = [Red, Green, Blue, Magenta, Cyan]


proc drawPentagon(img: var Image; x, y, side: float; depth: int) =
  var (x, y) = (x, y)
  var colorIndex {.global.} = 0
  var angle = 3 * Deg72
  if depth == 0:
    for _ in 0..4:
      let (prevx, prevy) = (x, y)
      x += cos(angle) * side
      y -= sin(angle) * side
      img.drawLine(prevx.toInt, prevy.toInt, x.toInt, y.toInt, Palette[colorIndex])
      angle += Deg72
    colorIndex = (colorIndex + 1) mod 5
  else:
    let side = side * ScaleFactor
    let dist = side * (1 + cos(Deg72) * 2)
    for _ in 0..4:
      x += cos(angle) * dist
      y -= sin(angle) * dist
      img.drawPentagon(x, y, side, depth - 1)
      angle += Deg72

var image = initImage[ColorRGBU](W, H)
image.fill(Black)
var order = 5
let hw = W / 2
let margin = 20.0
let radius = hw - 2 * margin
let side = radius * sin(PI / 5) * 2
image.drawPentagon(hw, 3 * margin, side, order - 1)
image.savePNG("Sierpinski_pentagon.png", compression = 9)
