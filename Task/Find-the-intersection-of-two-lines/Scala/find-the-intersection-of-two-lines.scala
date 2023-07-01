object Intersection extends App {
  val (l1, l2) = (LineF(PointF(4, 0), PointF(6, 10)), LineF(PointF(0, 3), PointF(10, 7)))

  def findIntersection(l1: LineF, l2: LineF): PointF = {
    val a1 = l1.e.y - l1.s.y
    val b1 = l1.s.x - l1.e.x
    val c1 = a1 * l1.s.x + b1 * l1.s.y

    val a2 = l2.e.y - l2.s.y
    val b2 = l2.s.x - l2.e.x
    val c2 = a2 * l2.s.x + b2 * l2.s.y

    val delta = a1 * b2 - a2 * b1
    // If lines are parallel, intersection point will contain infinite values
    PointF((b2 * c1 - b1 * c2) / delta, (a1 * c2 - a2 * c1) / delta)
  }

  def l01 = LineF(PointF(0f, 0f), PointF(1f, 1f))
  def l02 = LineF(PointF(1f, 2f), PointF(4f, 5f))

  case class PointF(x: Float, y: Float) {
    override def toString = s"{$x, $y}"
  }

  case class LineF(s: PointF, e: PointF)

  println(findIntersection(l1, l2))
  println(findIntersection(l01, l02))

}
