import math
import imageman

const
  Width = 400
  Height = 400

var img = initImage[ColorRGBF](Width, Height)
for x in 0..<Width:
  for y in 0..<Height:
    let fx = float32(x)
    let fy = float32(y)
    var hue = sin(fx / 16) + sin(fy / 8) + sin((fx + fy) / 16) + sin(sqrt((fx^2 + fy^2)) / 8)
    hue = (hue + 4) / 8   # Between 0 and 1.
    let rgb = to(ColorHSL([hue * 360, 1, 0.5]), ColorRGBF)
    img[x, y] = rgb
  img.savePNG("plasma.png")
