// version 1.1.2

data class Quaternion(val a: Double, val b: Double, val c: Double, val d: Double) {
    operator fun plus(other: Quaternion): Quaternion {
        return Quaternion (this.a + other.a, this.b + other.b,
                           this.c + other.c, this.d + other.d)
    }

    operator fun plus(r: Double) = Quaternion(a + r, b, c, d)

    operator fun times(other: Quaternion): Quaternion {
        return Quaternion(
            this.a * other.a - this.b * other.b - this.c * other.c - this.d * other.d,
            this.a * other.b + this.b * other.a + this.c * other.d - this.d * other.c,
            this.a * other.c - this.b * other.d + this.c * other.a + this.d * other.b,
            this.a * other.d + this.b * other.c - this.c * other.b + this.d * other.a
        )
    }

    operator fun times(r: Double) = Quaternion(a * r, b * r, c * r, d * r)

    operator fun unaryMinus() =  Quaternion(-a, -b, -c, -d)

    fun conj() = Quaternion(a, -b, -c, -d)

    fun norm() = Math.sqrt(a * a + b * b + c * c + d * d)

    override fun toString() = "($a, $b, $c, $d)"
}

// extension functions for Double type
operator fun Double.plus(q: Quaternion) = q + this
operator fun Double.times(q: Quaternion) = q * this

fun main(args: Array<String>) {
    val q  = Quaternion(1.0, 2.0, 3.0, 4.0)
    val q1 = Quaternion(2.0, 3.0, 4.0, 5.0)
    val q2 = Quaternion(3.0, 4.0, 5.0, 6.0)
    val r  = 7.0
    println("q  = $q")
    println("q1 = $q1")
    println("q2 = $q2")
    println("r  = $r\n")
    println("norm(q) = ${"%f".format(q.norm())}")
    println("-q      = ${-q}")
    println("conj(q) = ${q.conj()}\n")
    println("r  + q  = ${r + q}")
    println("q  + r  = ${q + r}")
    println("q1 + q2 = ${q1 + q2}\n")
    println("r  * q  = ${r * q}")
    println("q  * r  = ${q * r}")
    val q3 = q1 * q2
    val q4 = q2 * q1
    println("q1 * q2 = $q3")
    println("q2 * q1 = $q4\n")
    println("q1 * q2 != q2 * q1 = ${q3 != q4}")
}
