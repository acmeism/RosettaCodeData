// version 1.1.3

class Point(val x: Int, val y: Int) : Comparable<Point> {

    override fun compareTo(other: Point) = this.x.compareTo(other.x)

    override fun toString() = "($x, $y)"
}

fun convexHull(p: Array<Point>): List<Point> {
    if (p.isEmpty()) return emptyList()
    p.sort()
    val h = mutableListOf<Point>()

    // lower hull
    for (pt in p) {
        while (h.size >= 2 && !ccw(h[h.size - 2], h.last(), pt)) {
            h.removeAt(h.lastIndex)
        }
        h.add(pt)
    }

    // upper hull
    val t = h.size + 1
    for (i in p.size - 2 downTo 0) {
        val pt = p[i]
        while (h.size >= t && !ccw(h[h.size - 2], h.last(), pt)) {
            h.removeAt(h.lastIndex)
        }
        h.add(pt)
    }

    h.removeAt(h.lastIndex)
    return h
}

/* ccw returns true if the three points make a counter-clockwise turn */
fun ccw(a: Point, b: Point, c: Point) =
    ((b.x - a.x) * (c.y - a.y)) > ((b.y - a.y) * (c.x - a.x))

fun main(args: Array<String>) {
    val points = arrayOf(
        Point(16,  3), Point(12, 17), Point( 0,  6), Point(-4, -6), Point(16,  6),
        Point(16, -7), Point(16, -3), Point(17, -4), Point( 5, 19), Point(19, -8),
        Point( 3, 16), Point(12, 13), Point( 3, -4), Point(17,  5), Point(-3, 15),
        Point(-3, -9), Point( 0, 11), Point(-9, -3), Point(-4, -2), Point(12, 10)
    )
    val hull = convexHull(points)
    println("Convex Hull: $hull")
}
