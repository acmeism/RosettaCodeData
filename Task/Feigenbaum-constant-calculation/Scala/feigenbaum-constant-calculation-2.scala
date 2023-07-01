object Feigenbaum2 extends App {
  private val (max_it, max_it_j) = (13, 10)

  private def result = {

    @scala.annotation.tailrec
    def outer(i: Int, d1: Double, a2: Double, a1: Double, acc: Seq[Double]): Seq[Double] = {
      @scala.annotation.tailrec
      def center(j: Int, a: Double): Double = {
        @scala.annotation.tailrec
        def inner(k: Int, end: Int, x: Double, y: Double): (Double, Double) =
          if (k < end) inner(k + 1, end, a - x * x, 1.0 - 2.0 * y * x) else (x, y)

        val (x, y) = inner(0, 1 << i, 0.0, 0.0)
        if (j < max_it_j) {
          center(j + 1, a - (x / y))
        } else a
      }

      if (i <= max_it) {
        val a = center(0, a1 + (a1 - a2) / d1)
        val d: Double = (a1 - a2) / (a - a1)

        outer(i + 1, d, a1, a, acc :+ d)
      } else acc
    }

    outer(2, 3.2, 0, 1.0, Seq[Double]()).zipWithIndex
  }

  println(" i     ≈ δ")
  result.foreach { case (δ, i) => println(f"${i + 2}%2d  $δ%.8f") }

}
