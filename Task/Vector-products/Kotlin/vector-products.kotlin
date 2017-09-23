// version 1.1.2

class Vector3D(val x: Double, val y: Double, val z: Double) {
    infix fun dot(v: Vector3D) = x * v.x + y * v.y + z * v.z

    infix fun cross(v: Vector3D) =
        Vector3D(y * v.z - z * v.y, z * v.x - x * v.z, x * v.y - y * v.x)

    fun scalarTriple(v: Vector3D, w: Vector3D) = this dot (v cross w)

    fun vectorTriple(v: Vector3D, w: Vector3D) = this cross (v cross w)

    override fun toString() = "($x, $y, $z)"
}

fun main(args: Array<String>) {
    val a = Vector3D(3.0, 4.0, 5.0)
    val b = Vector3D(4.0, 3.0, 5.0)
    val c = Vector3D(-5.0, -12.0, -13.0)
    println("a = $a")
    println("b = $b")
    println("c = $c")
    println()
    println("a . b     = ${a dot b}")
    println("a x b     = ${a cross b}")
    println("a . b x c = ${a.scalarTriple(b, c)}")
    println("a x b x c = ${a.vectorTriple(b, c)}")
}
