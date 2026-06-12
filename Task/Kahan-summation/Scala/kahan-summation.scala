import scala.annotation.tailrec

object KahanSummation extends App {
  {
    def epsilon: Float = {
      @tailrec
      def eps(x: Float): Float = if (1 + x == 1) x else eps(x / 2)

      eps(1)
    }

    def kahanSum(fa: Float*): Float = {
      @tailrec
      def iter(fa: Seq[Float], c: Float, sum: Float): Float =
        if (fa.nonEmpty) {
          val y = fa.head - c
          val t = sum + y
          iter(fa.tail, (t - sum) - y, t)
        } else sum

      iter(fa, 0, 0)
    }

    val (a, ε) = (1f, epsilon)
    println(f"${"ε"}%-12s= ${ε}")
    println(f"(a + b) - b = ${(a + ε) - ε}")
    println("Kahan sum   = " + kahanSum(a, ε, -ε))
  }
}
