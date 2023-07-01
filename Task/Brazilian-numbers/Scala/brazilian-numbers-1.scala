object BrazilianNumbers {
  private val PRIME_LIST = List(
    2, 3, 5, 7, 9, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89,
    97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 169, 173, 179, 181,
    191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 247, 251, 257, 263, 269, 271, 277, 281,
    283, 293, 299, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 377, 379, 383, 389,
    397, 401, 403, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 481, 487, 491,
    499, 503, 509, 521, 523, 533, 541, 547, 557, 559, 563, 569, 571, 577, 587, 593, 599, 601, 607,
    611, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 689, 691, 701, 709, 719,
    727, 733, 739, 743, 751, 757, 761, 767, 769, 773, 787, 793, 797, 809, 811, 821, 823, 827, 829,
    839, 853, 857, 859, 863, 871, 877, 881, 883, 887, 907, 911, 919, 923, 929, 937, 941, 947, 949,
    953, 967, 971, 977, 983, 991, 997
  )

  def isPrime(n: Int): Boolean = {
    if (n < 2) {
      return false
    }

    for (prime <- PRIME_LIST) {
      if (n == prime) {
        return true
      }
      if (n % prime == 0) {
        return false
      }
      if (prime * prime > n) {
        return true
      }
    }

    val bigDecimal = BigInt.int2bigInt(n)
    bigDecimal.isProbablePrime(10)
  }

  def sameDigits(n: Int, b: Int): Boolean = {
    var n2 = n
    val f = n % b
    var done = false
    while (!done) {
      n2 /= b
      if (n2 > 0) {
        if (n2 % b != f) {
          return false
        }
      } else {
        done = true
      }
    }
    true
  }

  def isBrazilian(n: Int): Boolean = {
    if (n < 7) {
      return false
    }
    if (n % 2 == 0) {
      return true
    }
    for (b <- 2 until n - 1) {
      if (sameDigits(n, b)) {
        return true
      }
    }
    false
  }

  def main(args: Array[String]): Unit = {
    for (kind <- List("", "odd ", "prime ")) {
      var quiet = false
      var bigLim = 99999
      var limit = 20
      println(s"First $limit ${kind}Brazilian numbers:")
      var c = 0
      var n = 7
      while (c < bigLim) {
        if (isBrazilian(n)) {
          if (!quiet) {
            print(s"$n ")
          }
          c = c + 1
          if (c == limit) {
            println()
            println()
            quiet = true
          }
        }
        if (!quiet || kind == "") {
          if (kind == "") {
            n = n + 1
          } else if (kind == "odd ") {
            n = n + 2
          } else if (kind == "prime ") {
            do {
              n = n + 2
            } while (!isPrime(n))
          } else {
            throw new AssertionError("Oops")
          }
        }
      }
      if (kind == "") {
        println(s"The ${bigLim + 1}th Brazilian number is: $n")
        println()
      }
    }
  }
}
