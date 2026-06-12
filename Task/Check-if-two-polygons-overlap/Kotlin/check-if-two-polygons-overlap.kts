import kotlin.math.*

data class Vector2(val x: Double, val y: Double) {
    fun dot(other: Vector2): Double = this.x * other.x + this.y * other.y
}

class Projection(var min: Double = Double.POSITIVE_INFINITY, var max: Double = Double.NEGATIVE_INFINITY) {
    fun overlaps(proj2: Projection): Boolean = !(this.max < proj2.min || proj2.max < this.min)
}

class Polygon(vertices: List<Pair<Double, Double>>) {
    private val vertices: List<Vector2> = vertices.map { Vector2(it.first, it.second) }
    private val axes: List<Vector2> = getAxes()

    public fun getVertices(): List<Vector2> { return vertices}


    private fun getAxes(): List<Vector2> {
        val axes = mutableListOf<Vector2>()
        for (i in vertices.indices) {
            val vertex1 = vertices[i]
            val vertex2 = if (i + 1 == vertices.size) vertices[0] else vertices[i + 1]
            val edge = Vector2(vertex1.x - vertex2.x, vertex1.y - vertex2.y)
            axes.add(Vector2(-edge.y, edge.x))
        }
        return axes
    }

    fun projectionOnAxis(axis: Vector2): Projection {
        return Projection().apply {
            vertices.forEach { vertex ->
                val p = axis.dot(vertex)
                if (p < min) min = p
                if (p > max) max = p
            }
        }
    }

    fun overlaps(other: Polygon): Boolean {
        (this.axes + other.axes).forEach { axis ->
            val proj1 = this.projectionOnAxis(axis)
            val proj2 = other.projectionOnAxis(axis)
            if (!proj1.overlaps(proj2)) return false
        }
        return true
    }
}

fun main() {
    val poly1 = Polygon(listOf(0.0 to 0.0, 0.0 to 2.0, 1.0 to 4.0, 2.0 to 2.0, 2.0 to 0.0))
    val poly2 = Polygon(listOf(4.0 to 0.0, 4.0 to 2.0, 5.0 to 4.0, 6.0 to 2.0, 6.0 to 0.0))
    val poly3 = Polygon(listOf(1.0 to 0.0, 1.0 to 2.0, 5.0 to 4.0, 9.0 to 2.0, 9.0 to 0.0))
    val polygons = listOf(poly1, poly2, poly3)

    polygons.forEachIndexed { index, polygon ->
        println("poly${index + 1} = ${polygon.getVertices()}")
    }
    println("poly1 and poly2 overlap? ${polygons[0].overlaps(polygons[1])}")
    println("poly1 and poly3 overlap? ${polygons[0].overlaps(polygons[2])}")
    println("poly2 and poly3 overlap? ${polygons[1].overlaps(polygons[2])}")
}
