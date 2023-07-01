import java.math.MathContext

import scala.collection.mutable

abstract class Frac extends Comparable[Frac] {
  val num: BigInt
  val denom: BigInt

  def unary_-(): Frac = {
    Frac(-num, denom)
  }

  def +(rhs: Frac): Frac = {
    Frac(
      num * rhs.denom + rhs.num * denom,
      denom * rhs.denom
    )
  }

  def -(rhs: Frac): Frac = {
    Frac(
      num * rhs.denom - rhs.num * denom,
      denom * rhs.denom
    )
  }

  def *(rhs: Frac): Frac = {
    Frac(num * rhs.num, denom * rhs.denom)
  }

  override def compareTo(rhs: Frac): Int = {
    val ln = num * rhs.denom
    val rn = rhs.num * denom
    ln.compare(rn)
  }

  def canEqual(other: Any): Boolean = other.isInstanceOf[Frac]

  override def equals(other: Any): Boolean = other match {
    case that: Frac =>
      (that canEqual this) &&
        num == that.num &&
        denom == that.denom
    case _ => false
  }

  override def hashCode(): Int = {
    val state = Seq(num, denom)
    state.map(_.hashCode()).foldLeft(0)((a, b) => 31 * a + b)
  }

  override def toString: String = {
    if (denom == 1) {
      return s"$num"
    }
    s"$num/$denom"
  }
}

object Frac {
  val ZERO: Frac = Frac(0)
  val ONE: Frac = Frac(1)

  def apply(n: BigInt): Frac = new Frac {
    val num: BigInt = n
    val denom: BigInt = 1
  }

  def apply(n: BigInt, d: BigInt): Frac = {
    if (d == 0) {
      throw new IllegalArgumentException("Parameter d may not be zero.")
    }

    var nn = n
    var dd = d

    if (nn == 0) {
      dd = 1
    } else if (dd < 0) {
      nn = -nn
      dd = -dd
    }

    val g = nn.gcd(dd)
    if (g > 0) {
      nn /= g
      dd /= g
    }

    new Frac {
      val num: BigInt = nn
      val denom: BigInt = dd
    }
  }
}

object Faulhaber {
  def bernoulli(n: Int): Frac = {
    if (n < 0) {
      throw new IllegalArgumentException("n may not be negative or zero")
    }

    val a = Array.fill(n + 1)(Frac.ZERO)
    for (m <- 0 to n) {
      a(m) = Frac(1, m + 1)
      for (j <- m to 1 by -1) {
        a(j - 1) = (a(j - 1) - a(j)) * Frac(j)
      }
    }

    // returns 'first' Bernoulli number
    if (n != 1) {
      return a(0)
    }
    -a(0)
  }

  def binomial(n: Int, k: Int): Int = {
    if (n < 0 || k < 0 || n < k) {
      throw new IllegalArgumentException()
    }
    if (n == 0 || k == 0) {
      return 1
    }
    val num = (k + 1 to n).product
    val den = (2 to n - k).product
    num / den
  }

  def faulhaberTriangle(p: Int): List[Frac] = {
    val coeffs = mutable.MutableList.fill(p + 1)(Frac.ZERO)

    val q = Frac(1, p + 1)
    var sign = -1
    for (j <- 0 to p) {
      sign *= -1
      coeffs(p - j) = q * Frac(sign) * Frac(binomial(p + 1, j)) * bernoulli(j)
    }
    coeffs.toList
  }

  def main(args: Array[String]): Unit = {
    for (i <- 0 to 9) {
      val coeffs = faulhaberTriangle(i)
      for (coeff <- coeffs) {
        print("%5s  ".format(coeff))
      }
      println()
    }
    println()
  }
}
