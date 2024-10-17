// version 1.1.4

const val C = 7

class Pt(val x: Double, val y: Double) {
    val zero get() = Pt(Double.POSITIVE_INFINITY, Double.POSITIVE_INFINITY)

    val isZero get() = x > 1e20 || x < -1e20

    fun dbl(): Pt {
        if (isZero) return this
        val l = 3.0 * x * x / (2.0 * y)
        val t = l * l - 2.0 * x
        return Pt(t, l * (x - t) - y)
    }

    operator fun unaryMinus() = Pt(x, -y)

    operator fun plus(other: Pt): Pt {
        if (x == other.x && y == other.y) return dbl()
        if (isZero) return other
        if (other.isZero) return this
        val l = (other.y - y) / (other.x - x)
        val t = l * l - x - other.x
        return Pt(t, l * (x - t) - y)
    }

    operator fun times(n: Int): Pt {
        var r: Pt = zero
        var p = this
        var i = 1
        while (i <= n) {
            if ((i and n) != 0) r += p
            p = p.dbl()
            i = i shl 1
        }
        return r
    }

    override fun toString() =
        if (isZero) "Zero" else "(${"%.3f".format(x)}, ${"%.3f".format(y)})"
}

fun Double.toPt() = Pt(Math.cbrt(this * this - C), this)

fun main(args: Array<String>) {
    val a = 1.0.toPt()
    val b = 2.0.toPt()
    val c = a + b
    val d = -c
    println("a         = $a")
    println("b         = $b")
    println("c = a + b = $c")
    println("d = -c    = $d")
    println("c + d     = ${c + d}")
    println("a + b + d = ${a + b + d}")
    println("a * 12345 = ${a * 12345}")
}
