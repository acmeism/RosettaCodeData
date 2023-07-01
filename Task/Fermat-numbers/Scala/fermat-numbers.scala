import scala.collection.mutable
import scala.collection.mutable.ListBuffer

object FermatNumbers {
  def main(args: Array[String]): Unit = {
    println("First 10 Fermat numbers:")
    for (i <- 0 to 9) {
      println(f"F[$i] = ${fermat(i)}")
    }
    println()
    println("First 12 Fermat numbers factored:")
    for (i <- 0 to 12) {
      println(f"F[$i] = ${getString(getFactors(i, fermat(i)))}")
    }
  }

  private val TWO = BigInt(2)

  def fermat(n: Int): BigInt = {
    TWO.pow(math.pow(2.0, n).intValue()) + 1
  }

  def getString(factors: List[BigInt]): String = {
    if (factors.size == 1) {
      return s"${factors.head} (PRIME)"
    }

    factors.map(a => a.toString)
      .map(a => if (a.startsWith("-")) "(C" + a.replace("-", "") + ")" else a)
      .reduce((a, b) => a + " * " + b)
  }

  val COMPOSITE: mutable.Map[Int, String] = scala.collection.mutable.Map(
    9 -> "5529",
    10 -> "6078",
    11 -> "1037",
    12 -> "5488",
    13 -> "2884"
  )

  def getFactors(fermatIndex: Int, n: BigInt): List[BigInt] = {
    var n2 = n
    var factors = new ListBuffer[BigInt]
    var loop = true
    while (loop) {
      if (n2.isProbablePrime(100)) {
        factors += n2
        loop = false
      } else {
        if (COMPOSITE.contains(fermatIndex)) {
          val stop = COMPOSITE(fermatIndex)
          if (n2.toString.startsWith(stop)) {
            factors += -n2.toString().length
            loop = false
          }
        }
        if (loop) {
          val factor = pollardRhoFast(n2)
          if (factor == 0) {
            factors += n2
            loop = false
          } else {
            factors += factor
            n2 = n2 / factor
          }
        }
      }
    }

    factors.toList
  }

  def pollardRhoFast(n: BigInt): BigInt = {
    var x = BigInt(2)
    var y = BigInt(2)
    var z = BigInt(1)
    var d = BigInt(1)
    var count = 0

    var loop = true
    while (loop) {
      x = pollardRhoG(x, n)
      y = pollardRhoG(pollardRhoG(y, n), n)
      d = (x - y).abs
      z = (z * d) % n
      count += 1
      if (count == 100) {
        d = z.gcd(n)
        if (d != 1) {
          loop = false
        } else {
          z = BigInt(1)
          count = 0
        }
      }
    }

    println(s"    Pollard rho try factor $n")
    if (d == n) {
      return 0
    }
    d
  }

  def pollardRhoG(x: BigInt, n: BigInt): BigInt = ((x * x) + 1) % n
}
