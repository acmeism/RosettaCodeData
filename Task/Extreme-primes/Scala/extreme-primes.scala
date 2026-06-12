import scala.math.BigInt

object ExtremePrimesApp extends App {

  private def isPrime(num: BigInt): Boolean =
    require(num >= 0)
    num.isProbablePrime(certainty = 100)

  private def calcExtremePrimes(max: Int) =
    require(max > 0)
    LazyList
      .iterate(BigInt(1))(_ + 1)
      .filter(isPrime)
      .scanLeft((BigInt(0), BigInt(0))) { case ((_, sum), prime) =>
        (prime, sum + prime)
      }
      .tail // Skip the initial (0, 0)
      .filter { case (_, sum) => isPrime(sum) }
      .take(max)

  @main def main(): Unit =
    val firstN = 30
    val milestones = List(1_000, 2_000, 3_000, 4_000, 5_000, 10_000, 30_000, 40_000, 50_000)

    val extremePrimes = calcExtremePrimes(milestones.max).toList

    def printFirstNExtremePrimes(n: Int): Unit =
      println(s"The first $n extreme primes are:")
      extremePrimes
        .take(n)
        .map(_._2)
        .grouped(10)
        .foreach { group =>
          println(group.map("%8d".format(_)).mkString)
        }

    def printMilestoneExtremePrimes(milestones: List[Int]): Unit =
      println()
      milestones.foreach { milestone =>
        val (prime, sum) = extremePrimes.drop(milestone - 1).head
        println(
          f"The $milestone%5dth extreme prime is sum of primes upto $prime%10d: $sum%14d"
        )
      }

    def test(): Unit =
      printFirstNExtremePrimes(firstN)
      printMilestoneExtremePrimes(milestones)

    test()

  main()
}
