// version 1.1.2

class PointF(val x: Float, val y: Float) {
    override fun toString() = "{$x, $y}"
}

class LineF(val s: PointF, val e: PointF)

fun findIntersection(l1: LineF, l2: LineF): PointF {
    val a1 = l1.e.y - l1.s.y
    val b1 = l1.s.x - l1.e.x
    val c1 = a1 * l1.s.x + b1 * l1.s.y

    val a2 = l2.e.y - l2.s.y
    val b2 = l2.s.x - l2.e.x
    val c2 = a2 * l2.s.x + b2 * l2.s.y

    val delta = a1 * b2 - a2 * b1
    // If lines are parallel, intersection point will contain infinite values
    return PointF((b2 * c1 - b1 * c2) / delta, (a1 * c2 - a2 * c1) / delta)
}

fun main(args: Array<String>) {
    var l1 = LineF(PointF(4f, 0f), PointF(6f, 10f))
    var l2 = LineF(PointF(0f, 3f), PointF(10f, 7f))
    println(findIntersection(l1, l2))
    l1 = LineF(PointF(0f, 0f), PointF(1f, 1f))
    l2 = LineF(PointF(1f, 2f), PointF(4f, 5f))
    println(findIntersection(l1, l2))
}
