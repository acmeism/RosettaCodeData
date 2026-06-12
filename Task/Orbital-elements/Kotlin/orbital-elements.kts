// version 1.1.4-3

class Vector(val x: Double, val y: Double, val z: Double) {

    operator fun plus(other: Vector) = Vector(x + other.x, y + other.y, z + other.z)

    operator fun times(m: Double) = Vector(x * m, y * m, z * m)

    operator fun div(d: Double) = this * (1.0 / d)

    fun abs() = Math.sqrt(x * x + y * y + z * z)

    override fun toString() = "($x, $y, $z)"
}

fun orbitalStateVectors(
    semimajorAxis: Double,
    eccentricity: Double,
    inclination: Double,
    longitudeOfAscendingNode: Double,
    argumentOfPeriapsis: Double,
    trueAnomaly: Double
): Pair<Vector, Vector> {
    var i = Vector(1.0, 0.0, 0.0)
    var j = Vector(0.0, 1.0, 0.0)
    var k = Vector(0.0, 0.0, 1.0)

    fun mulAdd(v1: Vector, x1: Double, v2: Vector, x2: Double) = v1 * x1 + v2 * x2

    fun rotate(i: Vector, j: Vector, alpha: Double) =
        Pair(mulAdd(i, +Math.cos(alpha), j, Math.sin(alpha)),
             mulAdd(i, -Math.sin(alpha), j, Math.cos(alpha)))

    var p = rotate(i, j, longitudeOfAscendingNode)
    i = p.first; j = p.second
    p = rotate(j, k, inclination)
    j = p.first
    p = rotate(i, j, argumentOfPeriapsis)
    i = p.first; j = p.second

    val l = semimajorAxis * (if (eccentricity == 1.0) 2.0 else (1.0 - eccentricity * eccentricity))
    val c = Math.cos(trueAnomaly)
    val s = Math.sin(trueAnomaly)
    val r = l / (1.0 + eccentricity * c)
    val rprime = s * r * r / l
    val position = mulAdd(i, c, j, s) * r
    var speed = mulAdd(i, rprime * c - r * s, j, rprime * s + r * c)
    speed /= speed.abs()
    speed *= Math.sqrt(2.0 / r - 1.0 / semimajorAxis)
    return Pair(position, speed)
}

fun main(args: Array<String>) {
    val (position, speed) = orbitalStateVectors(
        semimajorAxis = 1.0,
        eccentricity = 0.1,
        inclination = 0.0,
        longitudeOfAscendingNode = 355.0 / (113.0 * 6.0),
        argumentOfPeriapsis = 0.0,
        trueAnomaly = 0.0
    )
    println("Position : $position")
    println("Speed    : $speed")
}
