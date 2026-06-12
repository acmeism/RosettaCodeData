import imageman

type
  FPoint = tuple[x, y: float]
  FPoints3 = array[3, FPoint]

func lagrange(p: FPoints3; x: float): float =
  (x-p[1].x) * (x-p[2].x) / (p[0].x-p[1].x) / (p[0].x-p[2].x) * p[0].y +
  (x-p[0].x) * (x-p[2].x) / (p[1].x-p[0].x) / (p[1].x-p[2].x) * p[1].y +
  (x-p[0].x) * (x-p[1].x) / (p[2].x-p[0].x) / (p[2].x-p[1].x) * p[2].y

func points(p: FPoints3; n: int): seq[Point] =
  result.setLen(2 * n + 1)
  var dx = (p[1].x - p[0].x) / float(n)
  for i in 0..<n:
    let x = p[0].x + dx * float(i)
    result[i] = (x.toInt, p.lagrange(x).toInt)
  dx = (p[2].x - p[1].x) / float(n)
  for i in n..2*n:
    let x = p[1].x + dx * float(i - n)
    result[i] = (x.toInt, p.lagrange(x).toInt)

const N = 50

const P: FPoints3 =[(10.0, 10.0), (100.0, 200.0), (200.0, 10.0)]

var img = initImage[ColorRGBF](210, 210)
img.fill(ColorRGBF([float32 1, 1, 1]))    # White background.
let color = ColorRGBF([float32 0, 0, 0])  # Black.
img.drawPolyline(closed = false, color, P.points(N))
img.savePNG("curve.png", compression = 9)
