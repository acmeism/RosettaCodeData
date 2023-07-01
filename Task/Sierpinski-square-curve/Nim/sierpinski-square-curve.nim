import math

type

  SierpinskiCurve = object
    x, y: float
    angle: float
    length: int
    file: File


proc line(sc: var SierpinskiCurve) =
  let theta = degToRad(sc.angle)
  sc.x += sc.length.toFloat * cos(theta)
  sc.y += sc.length.toFloat * sin(theta)
  sc.file.write " L", sc.x, ',', sc.y


proc execute(sc: var SierpinskiCurve; s: string) =
  sc.file.write 'M', sc.x, ',', sc.y
  for c in s:
    case c
    of 'F': sc.line()
    of '+': sc.angle = floorMod(sc.angle + 90, 360)
    of '-': sc.angle = floorMod(sc.angle - 90, 360)
    else: discard


func rewrite(s: string): string =
  for c in s:
    if c == 'X':
      result.add "XF-F+F-XF+F+XF-F+F-X"
    else:
      result.add c


proc write(sc: var SierpinskiCurve; size, length, order: int) =
  sc.length = length
  sc.x = (size - length) / 2
  sc.y = length.toFloat
  sc.angle = 0
  sc.file.write "<svg xmlns='http://www.w3.org/2000/svg' width='", size, "' height='", size, "'>\n"
  sc.file.write "<rect width='100%' height='100%' fill='white'/>\n"
  sc.file.write "<path stroke-width='1' stroke='black' fill='none' d='"
  var s = "F+XF+F+XF"
  for _ in 1..order: s = s.rewrite()
  sc.execute(s)
  sc.file.write "'/>\n</svg>\n"


let outfile = open("sierpinski_square.svg", fmWrite)
var sc = SierpinskiCurve(file: outfile)
sc.write(635, 5, 5)
outfile.close()
