import kotlin.math.max
import kotlin.math.min

private const val EPS = 0.001
private const val EPS_SQUARE = EPS * EPS

private fun test(t: Triangle, p: Point) {
    println(t)
    println("Point $p is within triangle ? ${t.within(p)}")
}

fun main() {
    var p1 = Point(1.5, 2.4)
    var p2 = Point(5.1, -3.1)
    var p3 = Point(-3.8, 1.2)
    var tri = Triangle(p1, p2, p3)
    test(tri, Point(0.0, 0.0))
    test(tri, Point(0.0, 1.0))
    test(tri, Point(3.0, 1.0))
    println()
    p1 = Point(1.0 / 10, 1.0 / 9)
    p2 = Point(100.0 / 8, 100.0 / 3)
    p3 = Point(100.0 / 4, 100.0 / 9)
    tri = Triangle(p1, p2, p3)
    val pt = Point(p1.x + 3.0 / 7 * (p2.x - p1.x), p1.y + 3.0 / 7 * (p2.y - p1.y))
    test(tri, pt)
    println()
    p3 = Point(-100.0 / 8, 100.0 / 6)
    tri = Triangle(p1, p2, p3)
    test(tri, pt)
}

class Point(val x: Double, val y: Double) {
    override fun toString(): String {
        return "($x, $y)"
    }
}

class Triangle(private val p1: Point, private val p2: Point, private val p3: Point) {
    private fun pointInTriangleBoundingBox(p: Point): Boolean {
        val xMin = min(p1.x, min(p2.x, p3.x)) - EPS
        val xMax = max(p1.x, max(p2.x, p3.x)) + EPS
        val yMin = min(p1.y, min(p2.y, p3.y)) - EPS
        val yMax = max(p1.y, max(p2.y, p3.y)) + EPS
        return !(p.x < xMin || xMax < p.x || p.y < yMin || yMax < p.y)
    }

    private fun nativePointInTriangle(p: Point): Boolean {
        val checkSide1 = side(p1, p2, p) >= 0
        val checkSide2 = side(p2, p3, p) >= 0
        val checkSide3 = side(p3, p1, p) >= 0
        return checkSide1 && checkSide2 && checkSide3
    }

    private fun distanceSquarePointToSegment(p1: Point, p2: Point, p: Point): Double {
        val p1P2SquareLength = (p2.x - p1.x) * (p2.x - p1.x) + (p2.y - p1.y) * (p2.y - p1.y)
        val dotProduct = ((p.x - p1.x) * (p2.x - p1.x) + (p.y - p1.y) * (p2.y - p1.y)) / p1P2SquareLength
        if (dotProduct < 0) {
            return (p.x - p1.x) * (p.x - p1.x) + (p.y - p1.y) * (p.y - p1.y)
        }
        if (dotProduct <= 1) {
            val pP1SquareLength = (p1.x - p.x) * (p1.x - p.x) + (p1.y - p.y) * (p1.y - p.y)
            return pP1SquareLength - dotProduct * dotProduct * p1P2SquareLength
        }
        return (p.x - p2.x) * (p.x - p2.x) + (p.y - p2.y) * (p.y - p2.y)
    }

    private fun accuratePointInTriangle(p: Point): Boolean {
        if (!pointInTriangleBoundingBox(p)) {
            return false
        }
        if (nativePointInTriangle(p)) {
            return true
        }
        if (distanceSquarePointToSegment(p1, p2, p) <= EPS_SQUARE) {
            return true
        }
        return if (distanceSquarePointToSegment(p2, p3, p) <= EPS_SQUARE) {
            true
        } else distanceSquarePointToSegment(p3, p1, p) <= EPS_SQUARE
    }

    fun within(p: Point): Boolean {
        return accuratePointInTriangle(p)
    }

    override fun toString(): String {
        return "Triangle[$p1, $p2, $p3]"
    }

    companion object {
        private fun side(p1: Point, p2: Point, p: Point): Double {
            return (p2.y - p1.y) * (p.x - p1.x) + (-p2.x + p1.x) * (p.y - p1.y)
        }
    }
}
