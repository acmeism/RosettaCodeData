import scala.math.{Pi, cos, exp}

object GaussLegendreQuadrature extends App {
  private val N = 5

  private def legeInte(a: Double, b: Double): Double = {
    val (c1, c2) = ((b - a) / 2, (b + a) / 2)
    val tuples: IndexedSeq[(Double, Double)] = {
      val lcoef = {
        val lcoef = Array.ofDim[Double](N + 1, N + 1)

        lcoef(0)(0) = 1
        lcoef(1)(1) = 1
        for (i <- 2 to N) {
          lcoef(i)(0) = -(i - 1) * lcoef(i - 2)(0) / i
          for (j <- 1 to i) lcoef(i)(j) =
            ((2 * i - 1) * lcoef(i - 1)(j - 1) - (i - 1) * lcoef(i - 2)(j)) / i
        }
        lcoef
      }

      def legeEval(n: Int, x: Double): Double =
        lcoef(n).take(n).foldRight(lcoef(n)(n))((o, s) => s * x + o)

      def legeDiff(n: Int, x: Double): Double =
        n * (x * legeEval(n, x) - legeEval(n - 1, x)) / (x * x - 1)

      @scala.annotation.tailrec
      def convergention(x0: Double, x1: Double): Double = {
        if (x0 == x1) x1
        else convergention(x1, x1 - legeEval(N, x1) / legeDiff(N, x1))
      }

      for {i <- 0 until 5
           x = convergention(0.0, cos(Pi * (i + 1 - 0.25) / (N + 0.5)))
           x1 = legeDiff(N, x)
           } yield (x, 2 / ((1 - x * x) * x1 * x1))
    }

    println(s"Roots: ${tuples.map(el => f" ${el._1}%10.6f").mkString}")
    println(s"Weight:${tuples.map(el => f" ${el._2}%10.6f").mkString}")

    c1 * tuples.map { case (lroot, weight) => weight * exp(c1 * lroot + c2) }.sum
  }

  println(f"Integrating exp(x) over [-3, 3]:\n\t${legeInte(-3, 3)}%10.8f,")
  println(f"compared to actual%n\t${exp(3) - exp(-3)}%10.8f")

}
