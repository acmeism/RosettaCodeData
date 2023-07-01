// version 1.1.3

class Point(val x: Int, val y: Int) {
    override fun toString() = "($x, $y)"
}

fun shoelaceArea(v: List<Point>): Double {
    val n = v.size
    var a = 0.0
    for (i in 0 until n - 1) {
        a += v[i].x * v[i + 1].y - v[i + 1].x * v[i].y
    }
    return Math.abs(a + v[n - 1].x * v[0].y - v[0].x * v[n -1].y) / 2.0
}

fun main(args: Array<String>) {
    val v = listOf(
        Point(3, 4), Point(5, 11), Point(12, 8), Point(9, 5), Point(5, 6)
    )
    val area = shoelaceArea(v)
    println("Given a polygon with vertices at $v,")
    println("its area is $area")
}
