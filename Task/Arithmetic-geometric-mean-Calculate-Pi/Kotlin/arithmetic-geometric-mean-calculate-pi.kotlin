import java.math.BigDecimal
import java.math.MathContext

val con1024 = MathContext(1024)
val bigTwo  = BigDecimal(2)
val bigFour = bigTwo * bigTwo

fun bigSqrt(bd: BigDecimal, con: MathContext): BigDecimal {
    var x0 = BigDecimal.ZERO
    var x1 = BigDecimal.valueOf(Math.sqrt(bd.toDouble()))
    while (x0 != x1) {
        x0 = x1
        x1 = bd.divide(x0, con).add(x0).divide(bigTwo, con)
    }
    return x1
}

fun main(args: Array<String>) {
    var a = BigDecimal.ONE
    var g = a.divide(bigSqrt(bigTwo, con1024), con1024)
    var t : BigDecimal
    var sum = BigDecimal.ZERO
    var pow = bigTwo
    while (a != g) {
        t = (a + g).divide(bigTwo, con1024)
        g = bigSqrt(a * g, con1024)
        a = t
        pow *= bigTwo
        sum += (a * a - g * g) * pow
    }
    val pi = (bigFour * a * a).divide(BigDecimal.ONE - sum, con1024)
    println(pi)
}
