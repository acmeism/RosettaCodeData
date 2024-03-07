import java.math.BigInteger

object ArithmeticDerivative extends App {

  println("Arithmetic derivatives for -99 to 100 inclusive:")
  for {
    n <- -99 to 100
    column = n + 100
  } print(f"${derivative(BigInteger.valueOf(n))}%4d${if (column % 10 == 0) "\n" else " "}")

  println()

  val seven = BigInteger.valueOf(7)
  for (power <- 1 to 20) {
    println(f"D(10^$power%d) / 7 = ${derivative(BigInteger.TEN.pow(power)).divide(seven)}")
  }

  def derivative(aNumber: BigInteger): BigInteger = {
    if (aNumber.signum == -1) {
      return derivative(aNumber.negate()).negate()
    }
    if (aNumber == BigInteger.ZERO || aNumber == BigInteger.ONE) {
      return BigInteger.ZERO
    }

    var divisor = BigInteger.TWO
    while (divisor.multiply(divisor).compareTo(aNumber) <= 0) {
      if (aNumber.mod(divisor).signum == 0) {
        val quotient = aNumber.divide(divisor)
        return quotient.multiply(derivative(divisor)).add(divisor.multiply(derivative(quotient)))
      }
      divisor = divisor.add(BigInteger.ONE)
    }
    BigInteger.ONE
  }

}
