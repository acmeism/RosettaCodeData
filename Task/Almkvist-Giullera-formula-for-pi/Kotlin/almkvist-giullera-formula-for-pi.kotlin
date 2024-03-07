import java.math.BigDecimal
import java.math.BigInteger
import java.math.MathContext
import java.math.RoundingMode

object CodeKt{

    @JvmStatic
    fun main(args: Array<String>) {
        println("n                                   Integer part")
        println("================================================")
        for (n in 0..9) {
            println(String.format("%d%47s", n, almkvistGiullera(n).toString()))
        }

        val decimalPlaces = 70
        val mathContext = MathContext(decimalPlaces + 1, RoundingMode.HALF_EVEN)
        val epsilon = BigDecimal.ONE.divide(BigDecimal.TEN.pow(decimalPlaces))
        var previous = BigDecimal.ONE
        var sum = BigDecimal.ZERO
        var pi = BigDecimal.ZERO
        var n = 0

        while (pi.subtract(previous).abs().compareTo(epsilon) >= 0) {
            val nextTerm = BigDecimal(almkvistGiullera(n)).divide(BigDecimal.TEN.pow(6 * n + 3), mathContext)
            sum = sum.add(nextTerm)
            previous = pi
            n += 1
            pi = BigDecimal.ONE.divide(sum, mathContext).sqrt(mathContext)
        }

        println("\npi to $decimalPlaces decimal places:")
        println(pi)
    }

    private fun almkvistGiullera(aN: Int): BigInteger {
        val term1 = factorial(6 * aN) * BigInteger.valueOf(32)
        val term2 = BigInteger.valueOf(532L * aN * aN + 126 * aN + 9)
        val term3 = factorial(aN).pow(6) * BigInteger.valueOf(3)
        return term1 * term2 / term3
    }

    private fun factorial(aNumber: Int): BigInteger {
        var result = BigInteger.ONE
        for (i in 2..aNumber) {
            result *= BigInteger.valueOf(i.toLong())
        }
        return result
    }

    private fun BigDecimal.sqrt(context: MathContext): BigDecimal {
        var x = BigDecimal(Math.sqrt(this.toDouble()), context)
        if (this == BigDecimal.ZERO) return BigDecimal.ZERO
        val two = BigDecimal.valueOf(2)
        while (true) {
            val y = this.divide(x, context)
            x = x.add(y).divide(two, context)
            val nextY = this.divide(x, context)
            if (y == nextY || y == nextY.add(BigDecimal.ONE.divide(BigDecimal.TEN.pow(context.precision), context))) {
                break
            }
        }
        return x
    }
}
