// version 1.1.2

import java.math.BigInteger
import java.math.BigDecimal

fun Double.isLong(tolerance: Double = 0.0) =
    (this - Math.floor(this)) <= tolerance || (Math.ceil(this) - this) <= tolerance

fun BigDecimal.isBigInteger() =
    try {
        this.toBigIntegerExact()
        true
    }
    catch (ex: ArithmeticException) {
        false
    }

class Rational(val num: Long, val denom: Long) {
    fun isLong() = num % denom == 0L

    override fun toString() = "$num/$denom"
}

class Complex(val real: Double, val imag: Double) {
    fun isLong() = real.isLong() && imag == 0.0

    override fun toString() =
        if (imag >= 0.0)
            "$real + ${imag}i"
        else
            "$real - ${-imag}i"
}

fun main(args: Array<String>) {
    val da = doubleArrayOf(25.000000, 24.999999, 25.000100)
    for (d in da) {
        val exact = d.isLong()
        println("${"%.6f".format(d)} is ${if (exact) "an" else "not an"} integer")
    }
    val tolerance = 0.00001
    println("\nWith a tolerance of ${"%.5f".format(tolerance)}:")
    for (d in da) {
        val fuzzy = d.isLong(tolerance)
        println("${"%.6f".format(d)} is ${if (fuzzy) "an" else "not an"} integer")
    }

    println()
    val fa = doubleArrayOf(-2.1e120, -5e-2, Double.NaN, Double.POSITIVE_INFINITY)
    for (f in fa) {
        val exact = if (f.isNaN() || f.isInfinite()) false
                    else BigDecimal(f.toString()).isBigInteger()
        println("$f is ${if (exact) "an" else "not an"} integer")
    }

    println()
    val ca = arrayOf(Complex(5.0, 0.0), Complex(5.0, -5.0))
    for (c in ca) {
        val exact = c.isLong()
        println("$c is ${if (exact) "an" else "not an"} integer")
    }

    println()
    val ra = arrayOf(Rational(24, 8), Rational(-5, 1), Rational(17, 2))
    for (r in ra) {
        val exact = r.isLong()
        println("$r is ${if (exact) "an" else "not an"} integer")
    }
}
