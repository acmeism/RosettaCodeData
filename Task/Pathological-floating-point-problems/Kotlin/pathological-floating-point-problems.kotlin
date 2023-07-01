// version 1.0.6

import java.math.*

const val LIMIT = 100

val con480  = MathContext(480)
val bigTwo =  BigDecimal(2)
val bigE    = BigDecimal("2.71828182845904523536028747135266249775724709369995") // precise enough!

fun main(args: Array<String>) {
    // v(n) sequence task
    val c1 = BigDecimal(111)
    val c2 = BigDecimal(1130)
    val c3 = BigDecimal(3000)
    var v1 = bigTwo
    var v2 = BigDecimal(-4)
    var v3:  BigDecimal
    for (i in 3 .. LIMIT) {
        v3 = c1 - c2.divide(v2, con480) + c3.divide(v2 * v1, con480)
        println("${"%3d".format(i)} : ${"%19.16f".format(v3)}")
        v1 = v2
        v2 = v3
    }

    // Chaotic Building Society task
    var balance = bigE - BigDecimal.ONE
    for (year in 1..25) balance = balance.multiply(BigDecimal(year), con480) - BigDecimal.ONE
    println("\nBalance after 25 years is ${"%18.16f".format(balance)}")

    // Siegfried Rump task
    val a  = BigDecimal(77617)
    val b  = BigDecimal(33096)
    val c4 = BigDecimal("333.75")
    val c5 = BigDecimal(11)
    val c6 = BigDecimal(121)
    val c7 = BigDecimal("5.5")
    var f  = c4 * b.pow(6, con480) + c7 * b.pow(8, con480) + a.divide(bigTwo * b, con480)
    val c8 = c5 * a.pow(2, con480) * b.pow(2, con480) - b.pow(6, con480) - c6 * b.pow(4, con480) - bigTwo
    f += c8 * a.pow(2, con480)
    println("\nf(77617.0, 33096.0) is ${"%18.16f".format(f)}")
}
