import java.awt.Color
import math.{floor => ipart, round, abs}

case class Point(x: Double, y: Double) {def swap = Point(y, x)}

def plotter(bm: RgbBitmap, c: Color)(x: Double, y: Double, v: Double) = {
  val X = round(x).toInt
  val Y = round(y).toInt
  val V = v.toFloat
  // tint the existing pixels
  val c1 = c.getRGBColorComponents(null)
  val c2 = bm.getPixel(X, Y).getRGBColorComponents(null)
  val c3 = (c1 zip c2).map{case (n, o) => n * V + o * (1 - V)}
  bm.setPixel(X, Y, new Color(c3(0), c3(1), c3(2)))
}

def drawLine(plotter: (Double,Double,Double) => _)(p1: Point, p2: Point) {
  def fpart(x: Double) = x - ipart(x)
  def rfpart(x: Double) = 1 - fpart(x)
  def avg(a: Float, b: Float) = (a + b) / 2

  val steep = abs(p2.y - p1.y) > abs(p2.x - p1.x)
  val (p3, p4) = if (steep) (p1.swap, p2.swap) else (p1, p2)
  val (a, b) = if (p3.x > p4.x) (p4, p3) else (p3, p4)
  val dx = b.x - a.x
  val dy = b.y - a.y
  val gradient = dy / dx
  var intery = 0.0

  def endpoint(xpxl: Double, yend: Double, xgap: Double) {
    val ypxl = ipart(yend)
    if (steep) {
      plotter(ypxl,   xpxl, rfpart(yend) * xgap)
      plotter(ypxl+1, xpxl,  fpart(yend) * xgap)
    } else {
      plotter(xpxl, ypxl  , rfpart(yend) * xgap)
      plotter(xpxl, ypxl+1,  fpart(yend) * xgap)
    }
  }

  // handle first endpoint
  var xpxl1 = round(a.x);
  {
    val yend = a.y + gradient * (xpxl1 - a.x)
    val xgap = rfpart(a.x + 0.5)
    endpoint(xpxl1, yend, xgap)
    intery = yend + gradient
  }

  // handle second endpoint
  val xpxl2 = round(b.x);
  {
    val yend = b.y + gradient * (xpxl2 - b.x)
    val xgap = fpart(b.x + 0.5)
    endpoint(xpxl2, yend, xgap)
  }

  // main loop
  for (x <- (xpxl1 + 1) to (xpxl2 - 1)) {
    if (steep) {
      plotter(ipart(intery)  , x, rfpart(intery))
      plotter(ipart(intery)+1, x,  fpart(intery))
    } else {
      plotter(x, ipart (intery),  rfpart(intery))
      plotter(x, ipart (intery)+1, fpart(intery))
    }
    intery = intery + gradient
  }
}
