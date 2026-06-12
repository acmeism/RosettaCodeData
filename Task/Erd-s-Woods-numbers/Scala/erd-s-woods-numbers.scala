object ErdosWoods {
  def erdősWoods(n: Int): BigInt = {
    var primes = List[Int]()
    var P: BigInt = 1
    var k = 1
    while (k < n) {
      if (P % k != 0) primes = primes :+ k
      P *= k * k
      k += 1
    }

    val divs = (0 until n).map { a =>
      Integer.parseInt(primes.map(p => if (a % p == 0) "1" else "0").mkString.reverse, 2)
    }
    val np = primes.length
    var partitions = List((0, 0, (1 << np) - 1))

    for (i <- (1 until n).sortBy(x => Integer.toBinaryString(divs(x) | divs(n - x)).reverse.indexOf('1')).reverse) {
      var newPartitions = List[(Int, Int, Int)]()
      val factors = divs(i)
      val otherFactors = divs(n - i)
      for (p <- partitions) {
        val (setA, setB, rPrimes) = p
        if ((factors & setA) != 0 || (otherFactors & setB) != 0) {
          newPartitions = newPartitions :+ p
        } else {
          for ((v, ix) <- Integer.toBinaryString(factors & rPrimes).reverse.zipWithIndex if v == '1') {
            val w = 1 << ix
            newPartitions = newPartitions :+ ((setA ^ w, setB, rPrimes ^ w))
          }
          for ((v, ix) <- Integer.toBinaryString(otherFactors & rPrimes).reverse.zipWithIndex if v == '1') {
            val w = 1 << ix
            newPartitions = newPartitions :+ ((setA, setB ^ w, rPrimes ^ w))
          }
        }
      }
      partitions = newPartitions
    }

    partitions.foldLeft(BigInt("1000000000000")) { (result, p) =>
      val (px, py, _) = p
      var x: BigInt = 1
      var y: BigInt = 1
      var pxVar = px
      var pyVar = py
      for (p <- primes) {
        if (pxVar % 2 == 1) x *= p
        if (pyVar % 2 == 1) y *= p
        pxVar /= 2
        pyVar /= 2
      }
      result.min(n * (x.modInverse(y)) % y * x - n)
    }
  }

  def main(args: Array[String]): Unit = {
    var K = 3
    var count = 0
    println("The first 20 Erdős–Woods numbers and their minimum interval start values are:")
    while (count < 20) {
      val a = erdősWoods(K)
      if (a != BigInt("1000000000000")) {
        println(f"$K%3d -> $a")
        count += 1
      }
      K += 1
    }
  }
}
