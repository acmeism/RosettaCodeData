import bitmap
import bresenham
import lenientops

proc drawQuadraticBezier*(
        image: Image; pt1, pt2, pt3: Point; color: Color; nseg: Positive = 20) =

  var points = newSeq[Point](nseg + 1)

  for i in 0..nseg:
    let t = i / nseg
    let a = (1 - t) * (1 - t)
    let b = 2 * t * (1 - t)
    let c = t * t

    points[i] = (x: (a * pt1.x + b * pt2.x + c * pt3.x).toInt,
                 y: (a * pt1.y + b * pt2.y + c * pt3.y).toInt)

  for i in 1..points.high:
    image.drawLine(points[i - 1], points[i], color)

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:
  var img = newImage(16, 12)
  img.fill(White)
  img.drawQuadraticBezier((1, 7), (7, 12), (14, 1), Black)
  img.print
