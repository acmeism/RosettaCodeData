object RandomNumbers extends App {

  val distribution: LazyList[Double] = {
    def randomNormal: Double = 1.0 + 0.5 * scala.util.Random.nextGaussian

    def normalDistribution(a: Double): LazyList[Double] = a #:: normalDistribution(randomNormal)

    normalDistribution(randomNormal)
  }

  /*
   * Let's test it
   */
  def calcAvgAndStddev[T](ts: Iterable[T])(implicit num: Fractional[T]): (T, Double) = {
    val mean: T =
      num.div(ts.sum, num.fromInt(ts.size)) // Leaving with type of function T

    // Root of mean diffs
    val stdDev = Math.sqrt(ts.map { x =>
      val diff = num.toDouble(num.minus(x, mean))
      diff * diff
    }.sum / ts.size)

    (mean, stdDev)
  }

  println(calcAvgAndStddev(distribution.take(1000))) // e.g. (1.0061433267806525,0.5291834867560893)
}
