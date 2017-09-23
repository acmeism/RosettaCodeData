// version 1.1.3

import java.math.BigInteger

val bigZero = BigInteger.ZERO
val bigOne = BigInteger.ONE
val bigThree = BigInteger.valueOf(3L)

data class BTernary(private var value: String) : Comparable<BTernary> {

    init {
        require(value.all { it in "0+-" })
        value = value.trimStart('0')
    }

    constructor(v: Int) : this(BigInteger.valueOf(v.toLong()))

    constructor(v: BigInteger) : this("") {
        value = toBT(v)
    }

    private fun toBT(v: BigInteger): String {
        if (v < bigZero) return flip(toBT(-v))
        if (v == bigZero) return ""
        val rem = mod3(v)
        return when (rem) {
            bigZero -> toBT(v / bigThree) + "0"
            bigOne  -> toBT(v / bigThree) + "+"
            else    -> toBT((v + bigOne) / bigThree) + "-"
        }
    }

    private fun flip(s: String): String {
        val sb = StringBuilder()
        for (c in s) {
            sb.append(when (c) {
                '+'  -> "-"
                '-'  -> "+"
                else -> "0"
            })
        }
        return sb.toString()
    }

    private fun mod3(v: BigInteger): BigInteger {
        if (v > bigZero) return v % bigThree
        return ((v % bigThree) + bigThree) % bigThree
    }

    fun toBigInteger(): BigInteger {
        val len = value.length
        var sum = bigZero
        var pow = bigOne
        for (i in 0 until len) {
            val c = value[len - i - 1]
            val dig = when (c) {
                '+'  -> bigOne
                '-'  -> -bigOne
                else -> bigZero
            }
            if (dig != bigZero) sum += dig * pow
            pow *= bigThree
        }
        return sum
    }

    private fun addDigits(a: Char, b: Char, carry: Char): String {
        val sum1 = addDigits(a, b)
        val sum2 = addDigits(sum1.last(), carry)
        return when {
            sum1.length == 1 -> sum2
            sum2.length == 1 -> sum1.take(1) + sum2
            else             -> sum1.take(1)
        }
    }

    private fun addDigits(a: Char, b: Char): String =
        when {
            a == '0' -> b.toString()
            b == '0' -> a.toString()
            a == '+' -> if (b == '+') "+-" else "0"
            else     -> if (b == '+') "0" else "-+"
        }

    operator fun plus(other: BTernary): BTernary {
        var a = this.value
        var b = other.value
        val longer = if (a.length > b.length) a else b
        var shorter = if (a.length > b.length) b else a
        while (shorter.length < longer.length) shorter = "0" + shorter
        a = longer
        b = shorter
        var carry = '0'
        var sum = ""
        for (i in 0 until a.length) {
            val place = a.length - i - 1
            val digisum = addDigits(a[place], b[place], carry)
            carry = if (digisum.length != 1) digisum[0] else '0'
            sum = digisum.takeLast(1) + sum
        }
        sum = carry.toString() + sum
        return BTernary(sum)
    }

    operator fun unaryMinus() = BTernary(flip(this.value))

    operator fun minus(other: BTernary) = this + (-other)

    operator fun times(other: BTernary): BTernary {
        var that = other
        val one = BTernary(1)
        val zero = BTernary(0)
        var mul = zero
        var flipFlag = false
        if (that < zero) {
            that = -that
            flipFlag = true
        }
        var i = one
        while (i <= that) {
            mul += this
            i += one
        }
        if (flipFlag) mul = -mul
        return mul
    }

    override operator fun compareTo(other: BTernary) =
        this.toBigInteger().compareTo(other.toBigInteger())

    override fun toString() = value
}

fun main(args: Array<String>) {
    val a = BTernary("+-0++0+")
    val b = BTernary(-436)
    val c = BTernary("+-++-")
    println("a = ${a.toBigInteger()}")
    println("b = ${b.toBigInteger()}")
    println("c = ${c.toBigInteger()}")
    val bResult = a * (b - c)
    val iResult = bResult.toBigInteger()
    println("a * (b - c) = $bResult = $iResult")
}
