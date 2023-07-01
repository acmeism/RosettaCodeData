// version 1.1.4

import java.math.BigDecimal
import java.math.BigInteger
import java.math.MathContext

object Hickerson {
    private const val LN2 = "0.693147180559945309417232121458"

    fun almostInteger(n: Int): Boolean {
        val a = BigDecimal(LN2).pow(n + 1) * BigDecimal(2)
        var nn = n
        var f = n.toLong()
        while (--nn > 1) f *= nn
        val b = BigDecimal(f).divide(a, MathContext.DECIMAL128)
        val c = b.movePointRight(1).toBigInteger() % BigInteger.TEN
        return c.toString().matches(Regex("[09]"))
    }
}

fun main(args: Array<String>) {
    for (n in 1..17) println("${"%2d".format(n)} is almost integer: ${Hickerson.almostInteger(n)}")
}
