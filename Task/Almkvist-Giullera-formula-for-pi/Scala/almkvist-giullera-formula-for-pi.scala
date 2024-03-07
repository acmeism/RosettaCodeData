import java.math.{BigDecimal, BigInteger, MathContext, RoundingMode}

object AlmkvistGiulleraFormula extends App {
  println("n                                   Integer part")
  println("================================================")
  for (n <- 0 to 9) {
    val term = almkvistGiullera(n).toString
    println(f"$n%1d" + " " * (47 - term.length) + term)
  }

  val decimalPlaces = 70
  val mathContext = new MathContext(decimalPlaces + 1, RoundingMode.HALF_EVEN)
  val epsilon = BigDecimal.ONE.divide(BigDecimal.TEN.pow(decimalPlaces))
  var previous = BigDecimal.ONE
  var sum = BigDecimal.ZERO
  var pi = BigDecimal.ZERO
  var n = 0

  while (pi.subtract(previous).abs.compareTo(epsilon) >= 0) {
    val nextTerm = new BigDecimal(almkvistGiullera(n)).divide(BigDecimal.TEN.pow(6 * n + 3))
    sum = sum.add(nextTerm)
    previous = pi
    n += 1
    pi = BigDecimal.ONE.divide(sum, mathContext).sqrt(mathContext)
  }

  println("\npi to " + decimalPlaces + " decimal places:")
  println(pi)

  def almkvistGiullera(aN: Int): BigInteger = {
    val term1 = factorial(6 * aN).multiply(BigInteger.valueOf(32))
    val term2 = BigInteger.valueOf(532 * aN * aN + 126 * aN + 9)
    val term3 = factorial(aN).pow(6).multiply(BigInteger.valueOf(3))
    term1.multiply(term2).divide(term3)
  }

  def factorial(aNumber: Int): BigInteger = {
    var result = BigInteger.ONE
    for (i <- 2 to aNumber) {
      result = result.multiply(BigInteger.valueOf(i))
    }
    result
  }
}
