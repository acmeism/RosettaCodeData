// version 1.1.2

class Vector2D(val x: Double, val y: Double) {
    operator fun plus(v: Vector2D) = Vector2D(x + v.x, y + v.y)

    operator fun minus(v: Vector2D) = Vector2D(x - v.x, y - v.y)

    operator fun times(s: Double) = Vector2D(s * x, s * y)

    operator fun div(s: Double) = Vector2D(x / s, y / s)

    override fun toString() = "($x, $y)"
}

operator fun Double.times(v: Vector2D) = v * this

fun main(args: Array<String>) {
    val v1 = Vector2D(5.0, 7.0)
    val v2 = Vector2D(2.0, 3.0)
    println("v1 = $v1")
    println("v2 = $v2")
    println()
    println("v1 + v2 = ${v1 + v2}")
    println("v1 - v2 = ${v1 - v2}")
    println("v1 * 11 = ${v1 * 11.0}")
    println("11 * v2 = ${11.0 * v2}")
    println("v1 / 2  = ${v1 / 2.0}")
}
