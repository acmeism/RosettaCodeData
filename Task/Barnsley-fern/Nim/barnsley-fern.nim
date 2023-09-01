import nimPNG, std/random

randomize()

const
  width = 640
  height = 640
  minX = -2.1815
  maxX = 2.6556
  minY = 0.0
  maxY = 9.9982
  iterations = 1_000_000

var img: array[width * height * 3, char]

proc floatToPixel(x,y:float): tuple[a:int,b:int] =
  var px = abs(x - minX) / abs(maxX - minX)
  var py = abs(y - minY) / abs(maxY - minY)

  var a:int = (int)(width * px)
  var b:int = (int)(height * py)

  a = a.clamp(0, width-1)
  b = b.clamp(0, height-1)
  # flip the y axis
  (a:a,b:height-b-1)

proc pixelToOffset(a,b: int): int =
  b * width * 3 + a * 3

proc toString(a: openArray[char]): string =
  result = newStringOfCap(a.len)

  for ch in items(a):
    result.add(ch)

proc drawPixel(x,y:float) =
  var (a,b) = floatToPixel(x,y)
  var offset = pixelToOffset(a,b)

  #img[offset] = 0 # red channel
  img[offset+1] = char(250) # green channel
  #img[offset+2] = 0 # blue channel

# main
var x, y: float = 0.0

for i in 1..iterations:
  var r = rand(101)
  var nx, ny: float
  if r <= 85:
    nx = 0.85 * x + 0.04 * y
    ny = -0.04 * x + 0.85 * y + 1.6
  elif r <= 85 + 7:
    nx = 0.2 * x - 0.26 * y
    ny = 0.23 * x + 0.22 * y + 1.6
  elif r <= 85 + 7 + 7:
    nx = -0.15 * x + 0.28 * y
    ny = 0.26 * x + 0.24 * y + 0.44
  else:
    nx = 0
    ny = 0.16 * y

  x = nx
  y = ny

  drawPixel(x,y)

discard savePNG24("fern.png",img.toString, width, height)
