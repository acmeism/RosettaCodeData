// version 1.1.51

typealias IAE = IllegalArgumentException

class Point(val x: Double, val y: Double) {
    fun distanceFrom(other: Point): Double {
        val dx = x - other.x
        val dy = y - other.y
        return Math.sqrt(dx * dx + dy * dy )
    }

    override fun equals(other: Any?): Boolean {
        if (other == null || other !is Point) return false
        return (x == other.x && y == other.y)
    }

    override fun toString() = "(%.4f, %.4f)".format(x, y)
}

fun findCircles(p1: Point, p2: Point, r: Double): Pair<Point, Point> {
    if (r < 0.0) throw IAE("the radius can't be negative")
    if (r == 0.0 && p1 != p2) throw IAE("no circles can ever be drawn")
    if (r == 0.0) return p1 to p1
    if (p1 == p2) throw IAE("an infinite number of circles can be drawn")
    val distance = p1.distanceFrom(p2)
    val diameter = 2.0 * r
    if (distance > diameter) throw IAE("the points are too far apart to draw a circle")
    val center = Point((p1.x + p2.x) / 2.0, (p1.y + p2.y) / 2.0)
    if (distance == diameter) return center to center
    val mirrorDistance = Math.sqrt(r * r - distance * distance / 4.0)
    val dx =  (p2.x - p1.x) * mirrorDistance / distance
    val dy =  (p2.y - p1.y) * mirrorDistance / distance
    return Point(center.x - dy, center.y + dx) to
           Point(center.x + dy, center.y - dx)
}

fun main(args: Array<String>) {
    val p = arrayOf(
        Point(0.1234, 0.9876),
        Point(0.8765, 0.2345),
        Point(0.0000, 2.0000),
        Point(0.0000, 0.0000)
    )
    val points = arrayOf(
        p[0] to p[1], p[2] to p[3], p[0] to p[0], p[0] to p[1], p[0] to p[0]
    )
    val radii = doubleArrayOf(2.0, 1.0, 2.0, 0.5, 0.0)
    for (i in 0..4) {
        try {
            val (p1, p2) = points[i]
            val r  = radii[i]
            println("For points $p1 and $p2 with radius $r")
            val (c1, c2) = findCircles(p1, p2, r)
            if (c1 == c2)
                println("there is just one circle with center at $c1")
            else
                println("there are two circles with centers at $c1 and $c2")
        }
        catch(ex: IllegalArgumentException) {
            println(ex.message)
        }
        println()
    }
}
