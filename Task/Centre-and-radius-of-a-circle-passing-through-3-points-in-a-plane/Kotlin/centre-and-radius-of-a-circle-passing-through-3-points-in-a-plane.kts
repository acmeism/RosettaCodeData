import kotlin.math.sqrt

data class Point(val x: Double, val y: Double)

fun findCircle(p1: Point, p2: Point, p3: Point): Pair<Point, Double> {
    fun sq(x: Double) = x * x
    val centreX =
        0.5 * (
            (sq(p1.x) + sq(p1.y)) * (p3.y - p2.y) +
            (sq(p2.x) + sq(p2.y)) * (p1.y - p3.y) +
            (sq(p3.x) + sq(p3.y)) * (p2.y - p1.y)
        ) / (
            p1.x * (p3.y - p2.y) +
            p2.x * (p1.y - p3.y) +
            p3.x * (p2.y - p1.y)
        )
    val centreY =
        0.5 * (
            (sq(p1.x) + sq(p1.y)) * (p3.x - p2.x) +
            (sq(p2.x) + sq(p2.y)) * (p1.x - p3.x) +
            (sq(p3.x) + sq(p3.y)) * (p2.x - p1.x)
        ) / (
            p1.y * (p3.x - p2.x) +
            p2.y * (p1.x - p3.x) +
            p3.y * (p2.x - p1.x)
            )
    val centre = Point(centreX, centreY)
    val radius = sqrt(sq(centreX - p1.x) + sq(centreY - p1.y))
    return Pair(centre, radius)
}

fun main() {
    findCircle(Point(22.83,2.07), Point(14.39,30.24), Point(33.65,17.31))
        .let { (c, r) ->
            println("Centre = $c")
            println("Radius = $r")
        }
}
