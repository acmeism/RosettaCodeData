// version 1.2.10

import kotlin.math.ceil

class Complex(val real: Double, val imag: Double) {

    constructor(r: Int, i: Int) : this(r.toDouble(), i.toDouble())

    operator fun plus(other: Complex) = Complex(real + other.real, imag + other.imag)

    operator fun times(other: Complex) = Complex(
        real * other.real - imag * other.imag,
        real * other.imag + imag * other.real
    )

    operator fun times(other: Double) = Complex(real * other, imag * other)

    fun inv(): Complex {
        val denom = real * real + imag * imag
        return Complex(real / denom, -imag / denom)
    }

    operator fun unaryMinus() = Complex(-real, -imag)

    operator fun minus(other: Complex) = this + (-other)

    operator fun div(other: Complex) = this * other.inv()

    // only works properly if 'real' and 'imag' are both integral
    fun toQuaterImaginary(): QuaterImaginary {
        if (real == 0.0 && imag == 0.0) return QuaterImaginary("0")
        var re = real.toInt()
        var im = imag.toInt()
        var fi = -1
        val sb = StringBuilder()
        while (re != 0) {
            var rem = re % -4
            re /= -4
            if (rem < 0) {
                rem = 4 + rem
                re++
            }
            sb.append(rem)
            sb.append(0)
        }
        if (im != 0) {
            var f = (Complex(0.0, imag) / Complex(0.0, 2.0)).real
            im = ceil(f).toInt()
            f = -4.0 * (f - im.toDouble())
            var index = 1
            while (im != 0) {
                var rem = im % -4
                im /= -4
                if (rem < 0) {
                    rem = 4 + rem
                    im++
                }
                if (index < sb.length) {
                    sb[index] = (rem + 48).toChar()
                }
                else {
                    sb.append(0)
                    sb.append(rem)
                }
                index += 2
            }
            fi = f.toInt()
        }
        sb.reverse()
        if (fi != -1) sb.append(".$fi")
        var s = sb.toString().trimStart('0')
        if (s.startsWith(".")) s = "0$s"
        return QuaterImaginary(s)
    }

    override fun toString(): String {
        val real2 = if (real == -0.0) 0.0 else real  // get rid of negative zero
        val imag2 = if (imag == -0.0) 0.0 else imag  // ditto
        var result = if (imag2 >= 0.0) "$real2 + ${imag2}i" else "$real2 - ${-imag2}i"
        result = result.replace(".0 ", " ").replace(".0i", "i").replace(" + 0i", "")
        if (result.startsWith("0 + ")) result = result.drop(4)
        if (result.startsWith("0 - ")) result = "-" + result.drop(4)
        return result
    }
}

class QuaterImaginary(val b2i: String) {

    init {
        if (b2i == "" || !b2i.all { it in "0123." } || b2i.count { it == '.'} > 1 )
            throw RuntimeException("Invalid Base 2i number")
    }

    fun toComplex(): Complex {
        val pointPos = b2i.indexOf(".")
        var posLen = if (pointPos != -1) pointPos else b2i.length
        var sum = Complex(0.0, 0.0)
        var prod = Complex(1.0, 0.0)
        for (j in 0 until posLen) {
            val k = (b2i[posLen - 1 - j] - '0').toDouble()
            if (k > 0.0) sum += prod * k
            prod *= twoI
        }
        if (pointPos != -1) {
            prod = invTwoI
            for (j in posLen + 1 until b2i.length) {
                val k = (b2i[j] - '0').toDouble()
                if (k > 0.0) sum += prod * k
                prod *= invTwoI
            }
        }
        return sum
    }

    override fun toString() = b2i

    companion object {
        val twoI = Complex(0.0, 2.0)
        val invTwoI = twoI.inv()
    }
}

fun main(args: Array<String>) {
    val fmt = "%4s -> %8s -> %4s"
    for (i in 1..16) {
        var c1 = Complex(i, 0)
        var qi = c1.toQuaterImaginary()
        var c2 = qi.toComplex()
        print("$fmt     ".format(c1, qi, c2))
        c1 = -c1
        qi = c1.toQuaterImaginary()
        c2 = qi.toComplex()
        println(fmt.format(c1, qi, c2))
    }
    println()
    for (i in 1..16) {
        var c1 = Complex(0, i)
        var qi = c1.toQuaterImaginary()
        var c2 = qi.toComplex()
        print("$fmt     ".format(c1, qi, c2))
        c1 = -c1
        qi = c1.toQuaterImaginary()
        c2 = qi.toComplex()
        println(fmt.format(c1, qi, c2))
    }
}
