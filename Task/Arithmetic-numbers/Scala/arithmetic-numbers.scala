object ArithmeticNumbers extends App {
  var arithmeticCount = 0
  var compositeCount = 0
  var n = 1

  while (arithmeticCount <= 1_000_000) {
    val factors = findFactors(n)
    val sum = factors.sum
    if (sum % factors.size == 0) {
      arithmeticCount += 1
      if (factors.size > 2) compositeCount += 1
      if (arithmeticCount <= 100) {
        print(f"$n%3d" + (if (arithmeticCount % 10 == 0) "\n" else " "))
      }
      if (List(1_000, 10_000, 100_000, 1_000_000).contains(arithmeticCount)) {
        println()
        println(s"${arithmeticCount}th arithmetic number is $n")
        println(s"Number of composite arithmetic numbers <= $n: $compositeCount")
      }
    }
    n += 1
  }

  def findFactors(number: Int): Set[Int] = {
    (1 to number).filter(number % _ == 0).toSet
  }
}
