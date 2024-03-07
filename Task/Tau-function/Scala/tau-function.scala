object TauFunction {

  private def divisorCount(n: Long): Long = {
    var count = 1L
    var number = n

    // Deal with powers of 2 first
    while ((number & 1L) == 0) {
      count += 1
      number >>= 1
    }

    // Odd prime factors up to the square root
    var p = 3L
    while (p * p <= number) {
      var tempCount = 1L
      while (number % p == 0) {
        tempCount += 1
        number /= p
      }
      count *= tempCount
      p += 2
    }

    // If n > 1 then it's prime
    if (number > 1) {
      count *= 2
    }

    count
  }

  def main(args: Array[String]): Unit = {
    val limit = 100
    println(s"Count of divisors for the first $limit positive integers:")
    for (n <- 1 to limit) {
      print(f"${divisorCount(n)}%3d")
      if (n % 20 == 0) println()
    }
  }
}
