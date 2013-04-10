object Exponentiation {
  import scala.annotation.tailrec

  @tailrec def powI[N](n: N, exponent: Int)(implicit num: Integral[N]): N = {
    import num._
    exponent match {
      case 0 => one
      case _ if exponent % 2 == 0 => powI((n * n), (exponent / 2))
      case _ => powI(n, (exponent - 1)) * n
    }
  }

  @tailrec def powF[N](n: N, exponent: Int)(implicit num: Fractional[N]): N = {
    import num._
    exponent match {
      case 0 => one
      case _ if exponent < 0 => one / powF(n, exponent.abs)
      case _ if exponent % 2 == 0 => powF((n * n), (exponent / 2))
      case _ => powF(n, (exponent - 1)) * n
    }
  }

  class ExponentI[N : Integral](n: N) {
    def \u2191(exponent: Int): N = powI(n, exponent)
  }

  class ExponentF[N : Fractional](n: N) {
    def \u2191(exponent: Int): N = powF(n, exponent)
  }

  object ExponentI {
    implicit def toExponentI[N : Integral](n: N): ExponentI[N] = new ExponentI(n)
  }

  object ExponentF {
    implicit def toExponentF[N : Fractional](n: N): ExponentF[N] = new ExponentF(n)
  }

  object Exponents {
    implicit def toExponent(n: Int): ExponentI[Int] = new ExponentI(n)
    implicit def toExponent(n: Double): ExponentF[Double] = new ExponentF(n)
  }
}
