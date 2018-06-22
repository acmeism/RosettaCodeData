import java.math.MathContext

import scala.annotation.tailrec
import scala.compat.Platform.currentTime
import scala.math.BigDecimal

object Calculate_Pi extends App {
  val precision = new MathContext(32768 /*65536*/)
  val (bigZero, bigOne, bigTwo, bigFour) =
    (BigDecimal(0, precision), BigDecimal(1, precision), BigDecimal(2, precision), BigDecimal(4, precision))

  def bigSqrt(bd: BigDecimal) = {
    @tailrec
    def iter(x0: BigDecimal, x1: BigDecimal): BigDecimal =
      if (x0 == x1) x1 else iter(x1, (bd / x1 + x1) / bigTwo)

    iter(bigZero, BigDecimal(Math.sqrt(bd.toDouble), precision))
  }

  @tailrec
  private def loop(a: BigDecimal, g: BigDecimal, sum: BigDecimal, pow: BigDecimal): BigDecimal = {
    if (a == g) (bigFour * (a * a)) / (bigOne - sum)
    else {
      val (_a, _g, _pow) = ((a + g) / bigTwo, bigSqrt(a * g), pow * bigTwo)
      loop(_a, _g, sum + ((_a * _a - (_g * _g)) * _pow), _pow)
    }
  }

  println(precision)
  val pi = loop(bigOne, bigOne / bigSqrt(bigTwo), bigZero, bigTwo)
  println(s"This are ${pi.toString.length - 1} digits of π:")
  val lines = pi.toString().sliding(103, 103).mkString("\n")
  println(lines)

  println(s"Successfully completed without errors. [total ${currentTime - executionStart} ms]")
}
