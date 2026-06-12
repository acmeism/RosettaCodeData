import java.util

object PolynomialSyntheticDivision extends App {

  val N: Array[Int] = Array(1, -12, 0, -42)
  val D: Array[Int] = Array(1, -3)

  def extendedSyntheticDivision(dividend: Array[Int],
                                divisor: Array[Int]): Array[Array[Int]] = {
    val out = dividend.clone
    val normalizer = divisor(0)

    for (i <- 0 until dividend.length - (divisor.length - 1)) {
      out(i) /= normalizer
      val coef = out(i)
      if (coef != 0)
        for (j <- 1 until divisor.length) out(i + j) += -divisor(j) * coef
    }
    val separator = out.length - (divisor.length - 1)
    Array[Array[Int]](util.Arrays.copyOfRange(out, 0, separator),
      util.Arrays.copyOfRange(out, separator, out.length))
  }

  println(f"${util.Arrays.toString(N)}%s / ${util.Arrays.toString(D)}%s = ${
    util.Arrays
      .deepToString(extendedSyntheticDivision(N, D).asInstanceOf[Array[AnyRef]])
  }%s")

}
