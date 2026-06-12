import org.apache.commons.math3.distribution.TDistribution

object WelchTTest extends App {

  val res = welchTtest(Array(3.0, 4.0, 1.0, 2.1), Array(490.2, 340.0, 433.9))

  def welchTtest(x: Array[Double], y: Array[Double]) = {

    def square[T](x: T)(implicit num: Numeric[T]): T = {
      import num._
      x * x
    }

    def count[A](a: Seq[A])(implicit num: Fractional[A]): A =
      a.foldLeft(num.zero) { case (cnt, _) => num.plus(cnt, num.one) }

    def mean[A](a: Seq[A])(implicit num: Fractional[A]): A = num.div(a.sum, count(a))

    def variance[A](a: Seq[A])(implicit num: Fractional[A]) =
      num.div(a.map(xs => square(num.minus(xs, mean(a)))).sum, num.minus(count(a), num.one))

    val (nx, ny) = (x.length, y.length)
    val (vx, vy) = (variance(x), variance(y))
    val qt = vx / nx + vy / ny
    val t = (mean(x) - mean(y)) / math.sqrt(qt)
    val df = square(qt) / (square(vx) / (square(nx) * (nx - 1)) + square(vy) / (square(ny) * (ny - 1)))
    val p = 2.0 * new TDistribution(df).cumulativeProbability(-math.abs(t))
    (t, df, p)
  }

  println(s"t  = ${res._1}\ndf = ${res._2}\np  = ${res._3}")
  println(s"\nSuccessfully completed without errors. [total ${scala.compat.Platform.currentTime - executionStart} ms]")

}
