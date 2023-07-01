object SafeAddition extends App {
  val (a, b) = (1.2, 0.03)
  val result = safeAdd(a, b)

  private def safeAdd(a: Double, b: Double) = Seq(stepDown(a + b), stepUp(a + b))

  private def stepDown(d: Double) = Math.nextAfter(d, Double.NegativeInfinity)

  private def stepUp(d: Double) = Math.nextUp(d)

  println(f"($a%.2f + $b%.2f) is in the range ${result.head}%.16f .. ${result.last}%.16f")

}
