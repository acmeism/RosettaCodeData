import math

import bitmap, grayscale_image, nimPNG

type

  Vector = array[3, float]

  Sphere = object
    cx, cy, cz: int
    r: int

#---------------------------------------------------------------------------------------------------

func dot(x, y: Vector): float {.inline.} =
  x[0] * y[0] + x[1] * y[1] + x[2] * y[2]

#---------------------------------------------------------------------------------------------------

func normalize(v: var Vector) =
  let invLen = 1 / sqrt(dot(v, v))
  v[0] *= invLen
  v[1] *= invLen
  v[2] *= invLen

#---------------------------------------------------------------------------------------------------

func hit(s: Sphere; x, y: int): tuple[z1, z2: float; hit: bool] =
  let x = x - s.cx
  let y = y - s.cy
  let zsq = s.r * s.r - (x * x + y * y)
  if zsq >= 0:
    let zsqrt = sqrt(zsq.toFloat)
    result = (s.cz.toFloat - zsqrt, s.cz.toFloat, true)
  else:
    result = (0.0, 0.0, false)

#---------------------------------------------------------------------------------------------------

func deathStar(pos, neg: Sphere; k, amb: float; dir: Vector): GrayImage =

  let w = pos.r * 4
  let h = pos.r * 3
  result = newGrayImage(w, h)
  var vect: Vector
  let deltaX = pos.cx - w div 2
  let deltaY = pos.cy - h div 2

  let xMax = pos.cx + pos.r
  let yMax = pos.cy + pos.r
  for y in (pos.cy - pos.r)..yMax:
    for x in (pos.cx - pos.r)..xMax:
      let (zb1, zb2, posHit) = pos.hit(x, y)
      if not posHit: continue
      var (zs1, zs2, negHit) = neg.hit(x, y)
      if negHit:
        if zs1 > zb1: negHit = false
        elif zs2 > zb2: continue
      if negHit:
        vect[0] = (neg.cx - x).toFloat
        vect[1] = (neg.cy - y).toFloat
        vect[2] = neg.cz.toFloat - zs2
      else:
        vect[0] = (x - pos.cx).toFloat
        vect[1] = (y - pos.cy).toFloat
        vect[2] = zb1 - pos.cz.toFloat
      vect.normalize()
      var s = dot(dir, vect)
      if s < 0: s = 0
      var lum = (255 * (s.pow(k) + amb) / (1 + amb)).toInt
      if lum < 0: lum = 0
      elif lum > 255: lum = 255
      result[x - deltaX, y - deltaY] = Luminance(lum)

#———————————————————————————————————————————————————————————————————————————————————————————————————

var dir: Vector = [float 20, -40, -10]
dir.normalize()
let pos = Sphere(cx: 0, cy: 0, cz: 0, r: 120)
let neg = Sphere(cx: -90, cy: -90, cz: -30, r: 100)

let grayImage = deathStar(pos, neg, 1.5, 0.2, dir)

# Save to PNG. We convert to an RGB image then transform the pixels
# in a sequence of bytes (actually a copy) in order to call "savePNG24".
let rgbImage = grayImage.toImage
var data = newSeqOfCap[byte](rgbImage.pixels.len * 3)
for color in rgbImage.pixels:
  data.add([color.r, color.g, color.b])
echo savePNG24("death_star.png", data, rgbImage.w, rgbImage.h)
