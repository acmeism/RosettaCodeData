import bitmap
import bresenham
import lenientops

proc drawCubicBezier*(
        image: Image; pt1, pt2, pt3, pt4: Point; color: Color; nseg: Positive = 20) =

  var points = newSeq[Point](nseg + 1)

  for i in 0..nseg:
    let t = i / nseg
    let u = (1 - t) * (1 - t)
    let a = (1 - t) * u
    let b = 3 * t * u
    let c = 3 * (t * t) * (1 - t)
    let d = t * t * t

    points[i] = (x: (a * pt1.x + b * pt2.x + c * pt3.x + d * pt4.x).toInt,
                 y: (a * pt1.y + b * pt2.y + c * pt3.y + d * pt4.y).toInt)

  for i in 1..points.high:
    image.drawLine(points[i - 1], points[i], color)

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:
  var img = newImage(16, 16)
  img.fill(White)
  img.drawCubicBezier((0, 15), (3, 0), (15, 2), (10, 14), Black)
  img.print
