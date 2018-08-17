object Roots extends App {
  val poly = (x: Double) => x * x * x - 3 * x * x + 2 * x

  private def printRoots(f: Double => Double,
                         lowerBound: Double,
                         upperBound: Double,
                         step: Double): Unit = {
    val y = f(lowerBound)
    var (ox, oy, os) = (lowerBound, y, math.signum(y))

    for (x <- lowerBound to upperBound by step) {
      val y = f(x)
      val s = math.signum(y)
      if (s == 0) println(x)
      else if (s != os) println(s"~${x - (x - ox) * (y / (y - oy))}")

      ox = x
      oy = y
      os = s
    }
  }

  printRoots(poly, -1.0, 4, 0.002)

}
