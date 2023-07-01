import scala.annotation.tailrec
import scala.collection.mutable
import scala.collection.mutable.{ArrayBuffer, ListBuffer}

abstract class Frac extends Comparable[Frac] {
  val num: BigInt
  val denom: BigInt

  def toEgyptian: List[Frac] = {
    if (num == 0) {
      return List(this)
    }

    val fracs = new ArrayBuffer[Frac]
    if (num.abs >= denom.abs) {
      val div = Frac(num / denom, 1)
      val rem = this - div
      fracs += div
      egyptian(rem.num, rem.denom, fracs)
    } else {
      egyptian(num, denom, fracs)
    }
    fracs.toList
  }

  @tailrec
  private def egyptian(n: BigInt, d: BigInt, fracs: mutable.Buffer[Frac]): Unit = {
    if (n == 0) {
      return
    }
    val n2 = BigDecimal.apply(n)
    val d2 = BigDecimal.apply(d)
    val (divbd, rembd) = d2./%(n2)
    var div = divbd.toBigInt()
    if (rembd > 0) {
      div = div + 1
    }
    fracs += Frac(1, div)
    var n3 = -d % n
    if (n3 < 0) {
      n3 = n3 + n
    }
    val d3 = d * div
    val f = Frac(n3, d3)
    if (f.num == 1) {
      fracs += f
      return
    }
    egyptian(f.num, f.denom, fracs)
  }

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

object EgyptianFractions {
  def main(args: Array[String]): Unit = {
    val fracs = List.apply(
      Frac(43, 48),
      Frac(5, 121),
      Frac(2014, 59)
    )
    for (frac <- fracs) {
      val list = frac.toEgyptian
      val it = list.iterator

      print(s"$frac -> ")
      if (it.hasNext) {
        val value = it.next()
        if (value.denom == 1) {
          print(s"[$value]")
        } else {
          print(value)
        }
      }
      while (it.hasNext) {
        val value = it.next()
        print(s" + $value")
      }
      println()
    }

    for (r <- List(98, 998)) {
      println()
      if (r == 98) {
        println("For proper fractions with 1 or 2 digits:")
      } else {
        println("For proper fractions with 1, 2 or 3 digits:")
      }

      var maxSize = 0
      var maxSizeFracs = new ListBuffer[Frac]
      var maxDen = BigInt(0)
      var maxDenFracs = new ListBuffer[Frac]
      val sieve = Array.ofDim[Boolean](r + 1, r + 2)
      for (i <- 0 until r + 1) {
        for (j <- i + 1 until r + 1) {
          if (!sieve(i)(j)) {
            val f = Frac(i, j)
            val list = f.toEgyptian
            val listSize = list.size
            if (listSize > maxSize) {
              maxSize = listSize
              maxSizeFracs.clear()
              maxSizeFracs += f
            } else if (listSize == maxSize) {
              maxSizeFracs += f
            }
            val listDen = list.last.denom
            if (listDen > maxDen) {
              maxDen = listDen
              maxDenFracs.clear()
              maxDenFracs += f
            } else if (listDen == maxDen) {
              maxDenFracs += f
            }
            if (i < r / 2) {
              var k = 2
              while (j * k <= r + 1) {
                sieve(i * k)(j * k) = true
                k = k + 1
              }
            }
          }
        }
      }
      println(s"  largest number of items = $maxSize")
      println(s"fraction(s) with this number : ${maxSizeFracs.toList}")
      val md = maxDen.toString()
      print(s"  largest denominator = ${md.length} digits, ")
      println(s"${md.substring(0, 20)}...${md.substring(md.length - 20)}")
      println(s"fraction(s) with this denominator : ${maxDenFracs.toList}")
    }
  }
}
