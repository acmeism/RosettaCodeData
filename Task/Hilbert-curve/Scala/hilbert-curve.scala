@js.annotation.JSExportTopLevel("ScalaFiddle")
object ScalaFiddle {
  // $FiddleStart
  import scala.util.Random

  case class Point(x: Int, y: Int)

  def xy2d(order: Int, d: Int): Point = {
    def rot(order: Int, p: Point, rx: Int, ry: Int): Point = {
      val np = if (rx == 1) Point(order - 1 - p.x, order - 1 - p.y) else p
      if (ry == 0) Point(np.y, np.x) else p
    }

    @scala.annotation.tailrec
    def iter(rx: Int, ry: Int, s: Int, t: Int, p: Point): Point = {
      if (s < order) {
        val _rx = 1 & (t / 2)
        val _ry = 1 & (t ^ _rx)
        val temp = rot(s, p, _rx, _ry)
        iter(_rx, _ry, s * 2, t / 4, Point(temp.x + s * _rx, temp.y + s * _ry))
      } else p
    }

    iter(0, 0, 1, d, Point(0, 0))
  }

  def randomColor =
    s"rgb(${Random.nextInt(240)}, ${Random.nextInt(240)}, ${Random.nextInt(240)})"

  val order = 64
  val factor = math.min(Fiddle.canvas.height, Fiddle.canvas.width) / order.toDouble
  val maxD = order * order
  var d = 0
  Fiddle.draw.strokeStyle = randomColor
  Fiddle.draw.lineWidth = 2
  Fiddle.draw.lineCap = "square"

  Fiddle.schedule(10) {
    val h = xy2d(order, d)
    Fiddle.draw.lineTo(h.x * factor, h.y * factor)
    Fiddle.draw.stroke
    if ({d += 1; d >= maxD})
    {d = 1; Fiddle.draw.strokeStyle = randomColor}
    Fiddle.draw.beginPath
    Fiddle.draw.moveTo(h.x * factor, h.y * factor)
  }
  // $FiddleEnd
}
