import scala.collection.mutable

object BlumInteger extends App {
  var blums = new Array[Int](50)
  var blumCount = 0
  val lastDigitCounts = mutable.Map[Int, Int]()
  var number = 1

  while (blumCount < 400_000) {
    val prime = leastPrimeFactor(number)
    if (prime % 4 == 3) {
      val quotient = number / prime
      if (quotient != prime && isPrimeType3(quotient)) {
        if (blumCount < 50) {
          blums(blumCount) = number
        }
        lastDigitCounts(number % 10) = lastDigitCounts.getOrElse(number % 10, 0) + 1
        blumCount += 1
        if (blumCount == 50) {
          println("The first 50 Blum integers:")
          blums.grouped(10).foreach(group => println(group.map(i => f"$i%3d").mkString(" ")))
          println("")
        } else if (blumCount == 26828 || blumCount % 100_000 == 0) {
          println(f"The ${blumCount}th Blum integer is: $number%7d")
          if (blumCount == 400_000) {
            println("\nPercent distribution of the first 400000 Blum integers:")
            lastDigitCounts.foreach { case (key, count) =>
              println(f"    ${count.toDouble / 4000}%6.3f%% end in $key")
            }
          }
        }
      }
    }
    number += (if (number % 5 == 3) 4 else 2)
  }

  def isPrimeType3(aNumber: Int): Boolean = {
    if (aNumber < 2) return false
    if (aNumber % 2 == 0) return aNumber == 2
    if (aNumber % 3 == 0) return aNumber == 3

    var divisor = 5
    while (divisor * divisor <= aNumber) {
      if (aNumber % divisor == 0) return false
      divisor += 2
    }
    aNumber % 4 == 3
  }

  def leastPrimeFactor(aNumber: Int): Int = {
    if (aNumber == 1) return 1
    if (aNumber % 2 == 0) return 2
    if (aNumber % 3 == 0) return 3

    var divisor = 5
    while (divisor * divisor <= aNumber) {
      if (aNumber % divisor == 0) return divisor
      divisor += 2
    }
    aNumber
  }
}
