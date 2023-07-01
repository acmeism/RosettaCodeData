from math import sin, cos, PI
import libgd

const
  width = 512
  height = 512
  iterations = 4

proc kochCurve(img: gdImagePtr, x1, y1, x2, y2: float, iter: int): void  =
  let angle = PI / 3 # 60 degrees
  let x3 = (x1 * 2 + x2) / 3
  let y3 = (y1 * 2 + y2) / 3
  let x4 = (x1 + x2 * 2) / 3
  let y4 = (y1 + y2 * 2) / 3
  let x5 = x3 + (x4 - x3) * cos(angle) + (y4 - y3) * sin(angle)
  let y5 = y3 - (x4 - x3) * sin(angle) + (y4 - y3) * cos(angle)

  if iter > 0:
    img.kochCurve(x1, y1, x3, y3, iter - 1)
    img.kochCurve(x3, y3, x5, y5, iter - 1)
    img.kochCurve(x5, y5, x4, y4, iter - 1)
    img.kochCurve(x4, y4, x2, y2, iter - 1)
  else:
    img.drawLine(startPoint=[x1.int, y1.int], endPoint=[x3.int, y3.int])
    img.drawLine(startPoint=[x3.int, y3.int], endPoint=[x5.int, y5.int])
    img.drawLine(startPoint=[x5.int, y5.int], endPoint=[x4.int, y4.int])
    img.drawLine(startPoint=[x4.int, y4.int], endPoint=[x2.int, y2.int])

proc main() =

  withGd imageCreate(width, height) as img:
    let white = img.backgroundColor(0xffffff)
    let red = img.foregroundColor(0xff0000)

    img.kochCurve(100, 100, 400, 400, iterations)

    let png_out = open("koch_curve.png", fmWrite)
    img.writePng(png_out)
    png_out.close()

main()
