object GiugaNumbers {

  private var results: List[Int] = List()
  def main(args: Array[String]): Unit = {
    val primes: List[Int] = List(2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59)

    val primeCounts: List[Int] = List(3, 4, 5)
    for (primeCount <- primeCounts) {
      var primeFactors: List[Int] = List.fill(primeCount)(0)
      combinations(primes, primeCount, 0, 0, primeFactors)
    }

    val sortedResults = results.sorted
    println(s"Found Giuga numbers: $sortedResults")
  }

  private def checkIfGiugaNumber(primeFactors: List[Int]): Unit = {
    val product: Int = primeFactors.reduce(Math.multiplyExact)
    for (factor <- primeFactors) {
      val divisor: Int = factor * factor
      if ((product - factor) % divisor != 0) {
        return
      }
    }
    results :+= product
  }

  private def combinations(primes: List[Int], primeCount: Int, index: Int, level: Int, primeFactors: List[Int]): Unit = {
    if (level == primeCount) {
      checkIfGiugaNumber(primeFactors)
      return
    }

    for (i <- index until primes.length) {
      val updatedPrimeFactors = primeFactors.updated(level, primes(i))
      combinations(primes, primeCount, i + 1, level + 1, updatedPrimeFactors)
    }
  }
}
