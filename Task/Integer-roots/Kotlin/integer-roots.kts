// version 1.1.2

import java.math.BigInteger

val bigZero = BigInteger.ZERO
val bigOne  = BigInteger.ONE
val bigTwo  = BigInteger.valueOf(2L)

fun BigInteger.iRoot(n: Int): BigInteger {
    require(this >= bigZero && n > 0)
    if (this < bigTwo) return this
    val n1 = n - 1
    val n2 = BigInteger.valueOf(n.toLong())
    val n3 = BigInteger.valueOf(n1.toLong())
    var c = bigOne
    var d = (n3 + this) / n2
    var e = (n3 * d + this / d.pow(n1)) / n2
    while (c != d && c != e) {
        c = d
        d = e
        e = (n3 * e + this / e.pow(n1)) / n2
    }
    return if (d < e) d else e
}

fun main(args: Array<String>) {
    var b: BigInteger
    b = BigInteger.valueOf(8L)
    println("3rd integer root of 8 = ${b.iRoot(3)}\n")
    b = BigInteger.valueOf(9L)
    println("3rd integer root of 9 = ${b.iRoot(3)}\n")
    b = BigInteger.valueOf(100L).pow(2000) * bigTwo
    println("First 2001 digits of the square root of 2:")
    println(b.iRoot(2))
}
