import scala.math.{Pi, cos}

object ChebyshevCoefficients extends App {
  final val N = 10
  final val (min, max) = (0, 1)
  val c = new Array[Double](N)

  def chebyshevCoef(func: Double => Double,
                    min: Double,
                    max: Double,
                    coef: Array[Double]): Unit =
    for (i <- coef.indices) {
      def map(x: Double,
              min_x: Double,
              max_x: Double,
              min_to: Double,
              max_to: Double): Double =
        (x - min_x) / (max_x - min_x) * (max_to - min_to) + min_to

      val m = map(cos(Pi * (i + 0.5f) / N), -1, 1, min, max)

      def f = func.apply(m) * 2 / N

      for (j <- coef.indices) coef(j) += f * cos(Pi * j * (i + 0.5f) / N)
    }

  chebyshevCoef((x: Double) => cos(x), min, max, c)
  println("Coefficients:")
  c.foreach(d => println(f"$d%23.16e"))

}
