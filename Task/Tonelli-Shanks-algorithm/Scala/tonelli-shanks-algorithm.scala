import java.math.BigInteger
import scala.collection.immutable.List
import scala.annotation.tailrec

object TonelliShanks {
  private val ZERO = BigInteger.ZERO
  private val ONE = BigInteger.ONE
  private val TEN = BigInteger.TEN
  private val TWO = BigInteger.valueOf(2)
  private val FOUR = BigInteger.valueOf(4)

  private case class Solution(root1: BigInteger, root2: BigInteger, exists: Boolean)

  private def ts(n: Long, p: Long): Solution = ts(BigInteger.valueOf(n), BigInteger.valueOf(p))

  private def ts(n: BigInteger, p: BigInteger): Solution = {
    val powModP: (BigInteger, BigInteger) => BigInteger = (a, e) => a.modPow(e, p)
    val ls: BigInteger => BigInteger = a => powModP(a, p.subtract(ONE).divide(TWO))

    if (!ls(n).equals(ONE)) return Solution(ZERO, ZERO, false)

    var q = p.subtract(ONE)
    var ss = ZERO
    while (q.and(ONE).equals(ZERO)) {
      ss = ss.add(ONE)
      q = q.shiftRight(1)
    }

    if (ss.equals(ONE)) {
      val r1 = powModP(n, p.add(ONE).divide(FOUR))
      return Solution(r1, p.subtract(r1), true)
    }

    var z = TWO
    while (!ls(z).equals(p.subtract(ONE))) z = z.add(ONE)
    var c = powModP(z, q)
    var r = powModP(n, q.add(ONE).divide(TWO))
    var t = powModP(n, q)
    var m = ss

    // Convert the while(true) loop to a tail-recursive function
    @tailrec
    def loop(r: BigInteger, c: BigInteger, t: BigInteger, m: BigInteger): Solution = {
      if (t.equals(ONE)) {
        Solution(r, p.subtract(r), true)
      } else {
        var i = ZERO
        var zz = t
        while (!zz.equals(BigInteger.ONE) && i.compareTo(m.subtract(ONE)) < 0) {
          zz = zz.multiply(zz).mod(p)
          i = i.add(ONE)
        }
        var b = c
        var e = m.subtract(i).subtract(ONE)
        while (e.compareTo(ZERO) > 0) {
          b = b.multiply(b).mod(p)
          e = e.subtract(ONE)
        }
        val newR = r.multiply(b).mod(p)
        val newC = b.multiply(b).mod(p)
        val newT = t.multiply(newC).mod(p)
        val newM = i
        loop(newR, newC, newT, newM)
      }
    }

    loop(r, c, t, m)
  }

  def main(args: Array[String]): Unit = {
    val pairs = List(
      (10L, 13L),
      (56L, 101L),
      (1030L, 10009L),
      (1032L, 10009L),
      (44402L, 100049L),
      (665820697L, 1000000009L),
      (881398088036L, 1000000000039L)
    )

    for ((n, p) <- pairs) {
      val sol = ts(n, p)
      println(s"n = $n")
      println(s"p = $p")
      if (sol.exists) {
        println(s"root1 = ${sol.root1}")
        println(s"root2 = ${sol.root2}")
      } else {
        println("No solution exists")
      }
      println()
    }

    val bn = new BigInteger("41660815127637347468140745042827704103445750172002")
    val bp = TEN.pow(50).add(BigInteger.valueOf(577))
    val sol = ts(bn, bp)
    println(s"n = $bn")
    println(s"p = $bp")
    if (sol.exists) {
      println(s"root1 = ${sol.root1}")
      println(s"root2 = ${sol.root2}")
    } else {
      println("No solution exists")
    }
  }
}
