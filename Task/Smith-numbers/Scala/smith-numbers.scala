object SmithNumbers extends App {

  def sumDigits(_n: Int): Int = {
    var n = _n
    var sum = 0
    while (n > 0) {
      sum += (n % 10)
      n /= 10
    }
    sum
  }

  def primeFactors(_n: Int): List[Int] = {
    var n = _n
    val result = new collection.mutable.ListBuffer[Int]
    val i = 2
    while (n % i == 0) {
      result += i
      n /= i
    }
    var j = 3
    while (j * j <= n) {
      while (n % j == 0) {
        result += i
        n /= j
      }
      j += 2
    }
    if (n != 1) result += n
    result.toList
  }

  for (n <- 1 until 10000) {
    val factors = primeFactors(n)
    if (factors.size > 1) {
      var sum = sumDigits(n)
      for (f <- factors) sum -= sumDigits(f)
      if (sum == 0) println(n)
    }
  }

}
