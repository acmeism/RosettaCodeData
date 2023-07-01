object Approximate extends App {
  val (ok, notOk, ε) = ("👌", "❌", 1e-18d)

  private def approxEquals(value: Double, other: Double, epsilon: Double) =
    scala.math.abs(value - other) < epsilon

  private def test(a: BigDecimal, b: BigDecimal, expected: Boolean): Unit = {
    val result = approxEquals(a.toDouble, b.toDouble, ε)
    println(f"$a%40.24f ≅ $b%40.24f => $result%5s ${if (expected == result) ok else notOk}")
  }

  test(BigDecimal("100000000000000.010"), BigDecimal("100000000000000.011"), true)
  test(BigDecimal("100.01"), BigDecimal("100.011"), false)
  test(BigDecimal(10000000000000.001 / 10000.0), BigDecimal("1000000000.0000001000"), false)
  test(BigDecimal("0.001"), BigDecimal("0.0010000001"), false)
  test(BigDecimal("0.000000000000000000000101"), BigDecimal(0), true)
  test(BigDecimal(math.sqrt(2) * math.sqrt(2d)), BigDecimal(2.0), false)
  test(BigDecimal(-Math.sqrt(2) * Math.sqrt(2)), BigDecimal(-2.0), false)
  test(BigDecimal("3.14159265358979323846"), BigDecimal("3.14159265358979324"), true)
}
