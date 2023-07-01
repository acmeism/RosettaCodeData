class Complex(private val real: Double, private val imag: Double) {
    operator fun plus(other: Complex) = Complex(real + other.real, imag + other.imag)

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

    fun conj() = Complex(real, -imag)

    override fun toString() =
        if (imag >= 0.0) "$real + ${imag}i"
        else "$real - ${-imag}i"
}

fun main(args: Array<String>) {
    val x = Complex(1.0, 3.0)
    val y = Complex(5.0, 2.0)
    println("x     =  $x")
    println("y     =  $y")
    println("x + y =  ${x + y}")
    println("x - y =  ${x - y}")
    println("x * y =  ${x * y}")
    println("x / y =  ${x / y}")
    println("-x    =  ${-x}")
    println("1 / x =  ${x.inv()}")
    println("x*    =  ${x.conj()}")
}
