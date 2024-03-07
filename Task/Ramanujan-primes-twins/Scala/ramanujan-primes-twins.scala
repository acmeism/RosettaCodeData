import java.util.{ArrayList, Arrays, List}

object RamanujanPrimesTwins {

  def main(args: Array[String]): Unit = {
    val limit = 1_000_000
    val primePi = initialisePrimePi(ramanujanMaximum(limit) + 1)
    val millionthRamanujanPrime = ramanujanPrime(primePi, limit)
    println(s"The 1_000_000th Ramanujan prime is $millionthRamanujanPrime")

    val primes = listPrimesLessThan(millionthRamanujanPrime)
    val ramanujanPrimeIndexes = new Array[Int](primes.size)
    for (i <- 0 until primes.size by 1) {
      ramanujanPrimeIndexes(i) = primePi(primes.get(i)) - primePi(primes.get(i) / 2)
    }

    var lowerLimit = ramanujanPrimeIndexes(ramanujanPrimeIndexes.length - 1)
    for (i <- ramanujanPrimeIndexes.length - 2 to 0 by -1) {
      if (ramanujanPrimeIndexes(i) < lowerLimit) {
        lowerLimit = ramanujanPrimeIndexes(i)
      } else {
        ramanujanPrimeIndexes(i) = 0
      }
    }

    val ramanujanPrimes = new ArrayList[Integer]()
    for (i <- 0 until ramanujanPrimeIndexes.size by 1) {
      if (ramanujanPrimeIndexes(i) != 0) {
        ramanujanPrimes.add(primes.get(i))
      }
    }

    var twinsCount = 0
    for (i <- 0 until ramanujanPrimes.size - 1) {
      if (ramanujanPrimes.get(i) + 2 == ramanujanPrimes.get(i + 1)) {
        twinsCount += 1
      }
    }
    println(s"There are $twinsCount twins in the first $limit Ramanujan primes.")
  }

  private def listPrimesLessThan(limit: Int): List[Integer] = {
    val composite = new Array[Boolean](limit + 1)
    var n = 3
    var nSquared = 9
    while (nSquared <= limit) {
      if (!composite(n)) {
        for (k <- nSquared until limit by (2*n) ) {
          composite(k) = true
        }
      }
      nSquared += (n + 1) << 2
      n += 2
    }

    var result = new ArrayList[Integer]()
    result.add(2)
    for (i <- 3 until limit by 2) {
      if (!composite(i)) {
        result.add(i)
      }
    }
    result
  }

  private def ramanujanPrime(primePi: Array[Int], number: Int): Int = {
    var maximum = ramanujanMaximum(number)
    if ((maximum & 1) == 1) {
      maximum -= 1
    }

    var index = maximum
    while (primePi(index) - primePi(index / 2) >= number) {
      index -= 1
    }
    index + 1
  }

  private def initialisePrimePi(aLimit : Int): Array[Int] = {
    val result = new Array[Int](aLimit )
    Arrays.fill(result, 1)
    result(0) = 0
    result(1) = 0
    for (i <- 4 until aLimit by 2) {
      result(i) = 0
    }

    var p = 3;var square = 9;
    while(square < aLimit) {
            if ( result(p) != 0 ) {
                for ( q <- square until aLimit by (p << 1) ) {
                    result(q) = 0;
                }
            }
            square += ( p + 1 ) << 2;
            p += 2
    }
    for (i <- 1 until result.length) {
      result(i) += result(i - 1)
    }
    result
  }

  private def ramanujanMaximum(number: Int): Int = {
    Math.ceil(4 * number * Math.log(4 * number)).toInt
  }
}
