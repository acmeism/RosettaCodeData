object CatalanNumbers {
  def main(args: Array[String]): Unit = {
    for (n <- 0 to 15) {
      println("catalan(" + n + ") = " + catalan(n))
    }
  }

  def catalan(n: BigInt): BigInt = factorial(2 * n) / (factorial(n + 1) * factorial(n))

  def factorial(n: BigInt): BigInt = BigInt(1).to(n).foldLeft(BigInt(1))(_ * _)
}
