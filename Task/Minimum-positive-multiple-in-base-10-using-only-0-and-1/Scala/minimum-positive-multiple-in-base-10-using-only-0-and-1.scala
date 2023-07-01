import scala.collection.mutable.ListBuffer

object MinimumNumberOnlyZeroAndOne {
  def main(args: Array[String]): Unit = {
    for (n <- getTestCases) {
      val result = getA004290(n)
      println(s"A004290($n) = $result = $n * ${result / n}")
    }
  }

  def getTestCases: List[Int] = {
    val testCases = ListBuffer.empty[Int]
    for (i <- 1 to 10) {
      testCases += i
    }
    for (i <- 95 to 105) {
      testCases += i
    }
    for (i <- Array(297, 576, 594, 891, 909, 999, 1998, 2079, 2251, 2277, 2439, 2997, 4878)) {
      testCases += i
    }
    testCases.toList
  }

  def getA004290(n: Int): BigInt = {
    if (n == 1) {
      return 1
    }
    val L = Array.ofDim[Int](n, n)
    for (i <- 2 until n) {
      L(0)(i) = 0
    }
    L(0)(0) = 1
    L(0)(1) = 1
    var m = 0
    val ten = BigInt(10)
    val nBi = BigInt(n)
    var loop = true
    while (loop) {
      m = m + 1
      if (L(m - 1)(mod(-ten.pow(m), nBi).intValue()) == 1) {
        loop = false
      } else {
        L(m)(0) = 1
        for (k <- 1 until n) {
          L(m)(k) = math.max(L(m - 1)(k), L(m - 1)(mod(BigInt(k) - ten.pow(m), nBi).toInt))
        }
      }
    }
    var r = ten.pow(m)
    var k = mod(-r, nBi)
    for (j <- m - 1 to 1 by -1) {
      if (L(j - 1)(k.toInt) == 0) {
        r = r + ten.pow(j)
        k = mod(k - ten.pow(j), nBi)
      }
    }
    if (k == 1) {
      r = r + 1
    }
    r
  }

  def mod(m: BigInt, n: BigInt): BigInt = {
    var result = m % n
    if (result < 0) {
      result = result + n
    }
    result
  }
}
