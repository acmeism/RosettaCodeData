import java.lang.Double.MAX_VALUE
import java.lang.Double.MIN_VALUE
import java.lang.Math.abs

data class Point(val x: Double, val y: Double)

data class Edge(val s: Point, val e: Point) {
    operator fun invoke(p: Point) : Boolean = when {
        s.y > e.y -> Edge(e, s).invoke(p)
        p.y == s.y || p.y == e.y -> invoke(Point(p.x, p.y + epsilon))
        p.y > e.y || p.y < s.y || p.x > Math.max(s.x, e.x) -> false
        p.x < Math.min(s.x, e.x) -> true
        else -> {
            val blue = if (abs(s.x - p.x) > MIN_VALUE) (p.y - s.y) / (p.x - s.x) else MAX_VALUE
            val red = if (abs(s.x - e.x) > MIN_VALUE) (e.y - s.y) / (e.x - s.x) else MAX_VALUE
            blue >= red
        }
    }

    val epsilon = 0.00001
}

class Figure(val name: String, val edges: Array<Edge>) {
    operator fun contains(p: Point) = edges.count({ it(p) }) % 2 != 0
}

object Ray_casting {
    fun check(figures : Array<Figure>, points : List<Point>) {
        println("points: " + points)
        figures.forEach { f ->
            println("figure: " + f.name)
            f.edges.forEach { println("        " + it) }
            println("result: " + (points.map { it in f }))
        }
    }
}
