import scala.math.sqrt

object StddevCalc extends App {

  def calcAvgAndStddev[T](ts: Iterable[T])(implicit num: Fractional[T]): (T, Double) = {
    def avg(ts: Iterable[T])(implicit num: Fractional[T]): T = {
      num.div(ts.sum, num.fromInt(ts.size)) // Leaving with type of function T
    }

    val mean = avg(ts) // Leave val type of T
    val stdDev = // Root of mean diffs
      sqrt(num.toDouble(
        ts.foldLeft(num.zero)((b, a) =>
          num.plus(b, num.times(num.minus(a, mean), num.minus(a, mean))))) /
        ts.size)
    (mean, stdDev)
  }

  def calcAvgAndStddev(ts: Iterable[BigDecimal]): (Double, Double) = // Overloaded for BigDecimal
    calcAvgAndStddev(ts.map(_.toDouble))

  println(calcAvgAndStddev(List(2.0E0, 4.0, 4, 4, 5, 5, 7, 9)))
  println(calcAvgAndStddev(Set(1.0, 2, 3, 4)))
  println(calcAvgAndStddev(0.1 to 1.1 by 0.05))
  println(calcAvgAndStddev(List(BigDecimal(120), BigDecimal(1200))))
}
