// version 1.1.51

class Vector3D(val x: Double, val y: Double, val z: Double) {

    operator fun plus(v: Vector3D) = Vector3D(x + v.x, y + v.y, z + v.z)

    operator fun minus(v: Vector3D) = Vector3D(x - v.x, y - v.y, z - v.z)

    operator fun times(s: Double) = Vector3D(s * x, s * y, s * z)

    infix fun dot(v: Vector3D) = x * v.x + y * v.y + z * v.z

    override fun toString() = "($x, $y, $z)"
}

fun intersectPoint(
    rayVector: Vector3D,
    rayPoint: Vector3D,
    planeNormal: Vector3D,
    planePoint: Vector3D
): Vector3D {
    val diff  = rayPoint - planePoint
    val prod1 = diff dot planeNormal
    val prod2 = rayVector dot planeNormal
    val prod3 = prod1 / prod2
    return rayPoint - rayVector * prod3
}

fun main(args: Array<String>) {
    val rv = Vector3D(0.0, -1.0, -1.0)
    val rp = Vector3D(0.0,  0.0, 10.0)
    val pn = Vector3D(0.0,  0.0,  1.0)
    val pp = Vector3D(0.0,  0.0,  5.0)
    val ip = intersectPoint(rv, rp, pn, pp)
    println("The ray intersects the plane at $ip")
}
