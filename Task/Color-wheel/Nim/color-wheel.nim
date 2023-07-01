import math

import imageman

#---------------------------------------------------------------------------------------------------

func hsvToRgb(h, s, v: float): ColorRGBU =
  ## Convert HSV values to RGB values.

  let hp = h / 60
  let c = s * v
  let x = c * (1 - abs(hp mod 2 - 1))
  let m = v - c
  var r, g, b = 0.0
  if hp <= 1:
    r = c
    g = x
  elif hp <= 2:
    r = x
    g = c
  elif hp <= 3:
    g = c
    b = x
  elif hp <= 4:
    g = x
    b= c
  elif hp <= 5:
    r = x
    b = c
  else:
    r = c
    b = x
  r += m
  g += m
  b += m
  result = ColorRGBU [byte(r * 255), byte(g * 255), byte(b * 255)]

#---------------------------------------------------------------------------------------------------

func buildColorWheel(image: var Image) =
  ## Build a color wheel into the image.

  const Margin = 10
  let diameter = min(image.w, image.h) - 2 * Margin
  let xOffset = (image.w - diameter) div 2
  let yOffset = (image.h - diameter) div 2
  let radius = diameter / 2

  for x in 0..diameter:
    let rx = x.toFloat - radius
    for y in 0..diameter:
      let ry = y.toFloat - radius
      let r = hypot(rx, ry) / radius
      if r > 1: continue
      let a = 180 + arctan2(ry, -rx).radToDeg()
      image[x + xOffset, y + yOffset] = hsvToRgb(a, r, 1)

#———————————————————————————————————————————————————————————————————————————————————————————————————

const
  Side = 400
  Output = "color_wheel.png"

var image = initImage[ColorRGBU](Side, Side)
image.buildColorWheel()

image.savePNG(Output, compression = 9)
