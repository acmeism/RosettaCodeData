import scala.annotation.tailrec
import scala.collection.mutable

object PrimeConspiracy extends App {
  val limit = 1000000
  val sieveTop = 15485863/*one millionth prime*/ + 1
  val buckets = Array.ofDim[Int](10, 10)
  var prevPrime = 2

  def sieve(limit: Int) = {
    val composite = new mutable.BitSet(sieveTop)
    composite(0) = true
    composite(1) = true

    for (n <- 2 to math.sqrt(limit).toInt)
      if (!composite(n)) for (k <- n * n until limit by n) composite(k) = true
    composite
  }

  val notPrime = sieve(sieveTop)

  def isPrime(n: Long) = {
    @tailrec
    def inner(d: Int, end: Int): Boolean = {
      if (d > end) true
      else if (n % d != 0 && n % (d + 2) != 0) inner(d + 6, end) else false
    }

    n > 1 && ((n & 1) != 0 || n == 2) &&
      (n % 3 != 0 || n == 3) && inner(5, math.sqrt(n).toInt)
  }

  var primeCount = 1
  var n = 3

  while (primeCount < limit) {
    if (!notPrime(n)) {
      val prime = n
      buckets(prevPrime % 10)(prime % 10) += 1
      prevPrime = prime
      primeCount += 1
    }
    n += 1
  }

  for {i <- buckets.indices
       j <- buckets.head.indices} {
    val nPrime = buckets(i)(j)
    if (nPrime != 0) println(f"$i%d -> $j%d : $nPrime%5d  ${nPrime / (limit / 100.0)}%2f")
  }

  println(s"Successfully completed without errors. [total ${scala.compat.Platform.currentTime - executionStart} ms]")
}
