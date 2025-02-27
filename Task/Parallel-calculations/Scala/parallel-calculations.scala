import scala.collection.parallel.CollectionConverters._

case class PrimeFactorInfo(
                            number: Int,
                            smallestPrimeFactor: Int,
                            primeFactors: List[Int]
                          )

def isPrime(n: Int): Boolean = {
  @annotation.tailrec
  def checkDivisor(d: Int): Boolean = {
    if (d * d > n) true
    else if (n % d == 0) false
    else checkDivisor(d + 2)
  }

  if (n < 2) false
  else if (n == 2 || n == 3) true
  else if (n % 2 == 0 || n % 3 == 0) false
  else checkDivisor(5)
}

def primeFactorInfo(n: Int): PrimeFactorInfo = {
  require(n > 1, "Number must be more than one")

  @annotation.tailrec
  def factorize(num: Int, currentFactor: Int = 2, factors: List[Int] = Nil): List[Int] = {
    if (num == 1) factors.reverse
    else if (isPrime(num)) (num :: factors).reverse
    else if (num % currentFactor == 0) factorize(num / currentFactor, currentFactor, currentFactor :: factors)
    else {
      val nextFactor = if (currentFactor == 2) 3 else currentFactor + 2
      factorize(num, nextFactor, factors)
    }
  }

  val factors = if (isPrime(n)) List(n)
  else factorize(n).sorted

  PrimeFactorInfo(n, factors.min, factors)
}

object ParallelCalculations extends App {

  private val numbers: List[Int] = List(
    12757923, 12878611, 12878893, 12757923, 15808973, 15780709, 197622519
  )
  private val info: List[PrimeFactorInfo] = numbers.par.map(primeFactorInfo).toList
  private val maxFactor: Int = info.map(_.smallestPrimeFactor).max
  private val results: List[PrimeFactorInfo] = info.filter(_.smallestPrimeFactor == maxFactor)

  println(s"The following number(s) have the largest minimal prime factor of $maxFactor:")
  results.foreach { result =>
    println(s"  ${result.number} whose prime factors are ${result.primeFactors.mkString(", ")}")
  }
}
