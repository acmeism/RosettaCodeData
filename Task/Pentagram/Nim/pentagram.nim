import libgd
from math import sin, cos, degToRad

const
  width = 500
  height = width
  outerRadius = 200

proc main() =

  proc calcPosition(x: int, y: int, radius: int, posAngle: float): (cint, cint) =
    var width = int(radius.float * sin(degToRad(posAngle)))
    var height = int(radius.float * cos(degToRad(posAngle)))
    return (cast[cint](x + width), cast[cint](y - height))

  proc getPentagonPoints(startAngle = 0, radius: int): array[5, array[2, int]] =
    let spacingAngle = 360 / 5

    var posAngle = (90 - startAngle).float

    var n = 0
    var points: array[5, array[2, int]]
    while n < 5:
      (points[n][0], points[n][1]) = calcPosition(250, 250, radius, posAngle)
      n += 1
      posAngle -= spacingAngle

    return points

  let outerPentagon = getPentagonPoints(18, outerRadius) # rotate 18 degrees
  let innerPentagon = getPentagonPoints(54, int((cos(degToRad(72.0))/cos(degToRad(36.0))) * outerRadius)) # rotate 54 degrees

  var pentagram: array[10, array[2, int]]
  var n = 0
  for i in countup(0, 4):
    pentagram[n] = outerPentagon[i]
    inc(n)
    pentagram[n] = innerPentagon[i]
    inc(n)

  withGd imageCreate(width, height) as img:
    discard img.setColor(255, 255, 255)

    let black = img.setColor(0x404040)
    let blue = img.setColor(0x6495ed)

    img.drawPolygon(
      points=pentagram,
      color=blue,
      fill=true,
      open=false)

    img.setThickness(4)

    img.drawPolygon(
      points=pentagram,
      color=black,
      fill=false,
      open=false)

    img.drawPolygon(
      points=innerPentagon,
      color=black,
      fill=false,
      open=false)

    let png_out = open("pentagram.png", fmWrite)
    img.writePng(png_out)

    png_out.close()

main()
