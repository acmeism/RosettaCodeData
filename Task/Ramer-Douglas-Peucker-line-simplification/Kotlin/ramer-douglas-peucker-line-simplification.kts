// version 1.1.0

typealias Point = Pair<Double, Double>

fun perpendicularDistance(pt: Point, lineStart: Point, lineEnd: Point): Double {
    var dx = lineEnd.first - lineStart.first
    var dy = lineEnd.second - lineStart.second

    // Normalize
    val mag = Math.hypot(dx, dy)
    if (mag > 0.0) { dx /= mag; dy /= mag }
    val pvx = pt.first - lineStart.first
    val pvy = pt.second - lineStart.second

    // Get dot product (project pv onto normalized direction)
    val pvdot = dx * pvx + dy * pvy

    // Scale line direction vector and substract it from pv
    val ax = pvx - pvdot * dx
    val ay = pvy - pvdot * dy

    return Math.hypot(ax, ay)
}

fun RamerDouglasPeucker(pointList: List<Point>, epsilon: Double, out: MutableList<Point>) {
    if (pointList.size < 2) throw IllegalArgumentException("Not enough points to simplify")

    // Find the point with the maximum distance from line between start and end
    var dmax = 0.0
    var index = 0
    val end = pointList.size - 1
    for (i in 1 until end) {
        val d = perpendicularDistance(pointList[i], pointList[0], pointList[end])
        if (d > dmax) { index = i; dmax = d }
    }

    // If max distance is greater than epsilon, recursively simplify
    if (dmax > epsilon) {
        val recResults1 = mutableListOf<Point>()
        val recResults2 = mutableListOf<Point>()
        val firstLine = pointList.take(index + 1)
        val lastLine  = pointList.drop(index)
        RamerDouglasPeucker(firstLine, epsilon, recResults1)
        RamerDouglasPeucker(lastLine, epsilon, recResults2)

        // build the result list
        out.addAll(recResults1.take(recResults1.size - 1))
        out.addAll(recResults2)
        if (out.size < 2) throw RuntimeException("Problem assembling output")
    }
    else {
        // Just return start and end points
        out.clear()
        out.add(pointList.first())
        out.add(pointList.last())
    }
}

fun main(args: Array<String>) {
    val pointList = listOf(
        Point(0.0, 0.0),
        Point(1.0, 0.1),
        Point(2.0, -0.1),
        Point(3.0, 5.0),
        Point(4.0, 6.0),
        Point(5.0, 7.0),
        Point(6.0, 8.1),
	Point(7.0, 9.0),
	Point(8.0, 9.0),
        Point(9.0, 9.0)
    )
    val pointListOut = mutableListOf<Point>()
    RamerDouglasPeucker(pointList, 1.0, pointListOut)
    println("Points remaining after simplification:")
    for (p in pointListOut) println(p)
}
