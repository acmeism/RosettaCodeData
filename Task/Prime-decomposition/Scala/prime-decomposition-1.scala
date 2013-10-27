import annotation.tailrec
import collection.parallel.mutable.ParSeq

object PrimeFactors extends App {
  def factorize(n: Long): List[Long] = {
    @tailrec
    def factors(tuple: (Long, Long, List[Long], Int)): List[Long] = {
      tuple match {
        case (1, _, acc, _)                 => acc
        case (n, k, acc, _) if (n % k == 0) => factors((n / k, k, acc ++ ParSeq(k), Math.sqrt(n / k).toInt))
        case (n, k, acc, sqr) if (k < sqr)  => factors(n, k + 1, acc, sqr)
        case (n, k, acc, sqr) if (k >= sqr) => factors((1, k, acc ++ ParSeq(n), 0))
      }
    }
    factors((n, 2, List[Long](), Math.sqrt(n).toInt))
  }

  def mersenne(p: Int): BigInt = (BigInt(2) pow p) - 1

  def sieve(nums: Stream[Int]): Stream[Int] =
    Stream.cons(nums.head, sieve((nums.tail) filter (_ % nums.head != 0)))
  // An infinite stream of primes, lazy evaluation and memo-ized
  val oddPrimes = sieve(Stream.from(3, 2))
  def primes = sieve(2 #:: oddPrimes)

  oddPrimes takeWhile (_ <= 59) foreach { p =>
    { // Needs some intermediate results for nice formatting
      val numM = s"M${p}"
      val nMersenne = mersenne(p).toLong
      val lit = f"${nMersenne}%30d"

      val datum = System.nanoTime
      val result = factorize(nMersenne)
      val mSec = ((System.nanoTime - datum) / 1.e+6).round

      def decStr = { if (lit.length > 30) f"(M has ${lit.length}%3d dec)" else "" }
      def sPrime = { if (result.isEmpty) " is a Mersenne prime number." else "" }

      println(
        f"$numM%4s = 2^$p%03d - 1 = ${lit}%s${sPrime} ($mSec%,4d msec) composed of ${result.mkString(" × ")}")
    }
  }
}
