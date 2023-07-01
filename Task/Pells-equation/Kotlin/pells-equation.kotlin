import java.math.BigInteger
import kotlin.math.sqrt

class BIRef(var value: BigInteger) {
    operator fun minus(b: BIRef): BIRef {
        return BIRef(value - b.value)
    }

    operator fun times(b: BIRef): BIRef {
        return BIRef(value * b.value)
    }

    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as BIRef

        if (value != other.value) return false

        return true
    }

    override fun hashCode(): Int {
        return value.hashCode()
    }

    override fun toString(): String {
        return value.toString()
    }
}

fun f(a: BIRef, b: BIRef, c: Int) {
    val t = a.value
    a.value = b.value
    b.value = b.value * BigInteger.valueOf(c.toLong()) + t
}

fun solvePell(n: Int, a: BIRef, b: BIRef) {
    val x = sqrt(n.toDouble()).toInt()
    var y = x
    var z = 1
    var r = x shl 1
    val e1 = BIRef(BigInteger.ONE)
    val e2 = BIRef(BigInteger.ZERO)
    val f1 = BIRef(BigInteger.ZERO)
    val f2 = BIRef(BigInteger.ONE)
    while (true) {
        y = r * z - y
        z = (n - y * y) / z
        r = (x + y) / z
        f(e1, e2, r)
        f(f1, f2, r)
        a.value = f2.value
        b.value = e2.value
        f(b, a, x)
        if (a * a - BIRef(n.toBigInteger()) * b * b == BIRef(BigInteger.ONE)) {
            return
        }
    }
}

fun main() {
    val x = BIRef(BigInteger.ZERO)
    val y = BIRef(BigInteger.ZERO)
    intArrayOf(61, 109, 181, 277).forEach {
        solvePell(it, x, y)
        println("x^2 - %3d * y^2 = 1 for x = %,27d and y = %,25d".format(it, x.value, y.value))
    }
}
