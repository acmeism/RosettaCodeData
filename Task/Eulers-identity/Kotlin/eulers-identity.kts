// Version 1.2.40

import kotlin.math.sqrt
import kotlin.math.PI

const val EPSILON = 1.0e-16
const val SMALL_PI = '\u03c0'
const val APPROX_EQUALS = '\u2245'

class Complex(val real: Double, val imag: Double) {
    operator fun plus(other: Complex) =
        Complex(real + other.real, imag + other.imag)

    operator fun times(other: Complex) = Complex(
        real * other.real - imag * other.imag,
        real * other.imag + imag * other.real
    )

    fun inv(): Complex {
        val denom = real * real + imag * imag
        return Complex(real / denom, -imag / denom)
    }

    operator fun unaryMinus() = Complex(-real, -imag)

    operator fun minus(other: Complex) = this + (-other)

    operator fun div(other: Complex) = this * other.inv()

    val modulus: Double get() = sqrt(real * real + imag * imag)

    override fun toString() =
        if (imag >= 0.0) "$real + ${imag}i"
        else "$real - ${-imag}i"
}

fun main(args: Array<String>) {
    var fact = 1.0
    val x = Complex(0.0, PI)
    var e = Complex(1.0, PI)
    var n = 2
    var pow = x
    do {
        val e0 = e
        fact *= n++
        pow *= x
        e += pow / Complex(fact, 0.0)
    }
    while ((e - e0).modulus >= EPSILON)
    e += Complex(1.0, 0.0)
    println("e^${SMALL_PI}i + 1 = $e $APPROX_EQUALS 0")
}
