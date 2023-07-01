object CircularPrimes {
  def main(args: Array[String]): Unit = {
    println("First 19 circular primes:")
    var p = 2
    var count = 0
    while (count < 19) {
      if (isCircularPrime(p)) {
        if (count > 0) {
          print(", ")
        }
        print(p)
        count += 1
      }
      p += 1
    }
    println()

    println("Next 4 circular primes:")
    var repunit = 1
    var digits = 1
    while (repunit < p) {
      repunit = 10 * repunit + 1
      digits += 1
    }
    var bignum = BigInt.apply(repunit)
    count = 0
    while (count < 4) {
      if (bignum.isProbablePrime(15)) {
        if (count > 0) {
          print(", ")
        }
        print(s"R($digits)")
        count += 1
      }
      digits += 1
      bignum = bignum * 10
      bignum = bignum + 1
    }
    println()

    testRepunit(5003)
    testRepunit(9887)
    testRepunit(15073)
    testRepunit(25031)
  }

  def isPrime(n: Int): Boolean = {
    if (n < 2) {
      return false
    }
    if (n % 2 == 0) {
      return n == 2
    }
    if (n % 3 == 0) {
      return n == 3
    }
    var p = 5
    while (p * p <= n) {
      if (n % p == 0) {
        return false
      }
      p += 2
      if (n % p == 0) {
        return false
      }
      p += 4
    }
    true
  }

  def cycle(n: Int): Int = {
    var m = n
    var p = 1
    while (m >= 10) {
      p *= 10
      m /= 10
    }
    m + 10 * (n % p)
  }

  def isCircularPrime(p: Int): Boolean = {
    if (!isPrime(p)) {
      return false
    }
    var p2 = cycle(p)
    while (p2 != p) {
      if (p2 < p || !isPrime(p2)) {
        return false
      }
      p2 = cycle(p2)
    }
    true
  }

  def testRepunit(digits: Int): Unit = {
    val ru = repunit(digits)
    if (ru.isProbablePrime(15)) {
      println(s"R($digits) is probably prime.")
    } else {
      println(s"R($digits) is not prime.")
    }
  }

  def repunit(digits: Int): BigInt = {
    val ch = Array.fill(digits)('1')
    BigInt.apply(new String(ch))
  }
}
