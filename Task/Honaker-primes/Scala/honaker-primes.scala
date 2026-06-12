import scala.collection.mutable.ListBuffer

object HonakerPrimes {
  def main(args: Array[String]): Unit = {
    sievePrimes(5000000)

    println("The first 50 Honaker primes (honaker index: prime index, prime):")
    for (i <- 1 to 50) {
      print(f"${nextHonakerPrime()}%17s${if (i % 5 == 0) "\n" else " "}")
    }
    for (i <- 51 until 10000) {
      nextHonakerPrime()
    }
    println()
    println(s"The 10,000th Honaker prime is: ${nextHonakerPrime()}")
  }

  private def nextHonakerPrime(): HonakerPrime = {
    honakerIndex += 1
    primeIndex += 1
    while (digitalSum(primeIndex) != digitalSum(primes(primeIndex - 1))) {
      primeIndex += 1
    }
    HonakerPrime(honakerIndex, primeIndex, primes(primeIndex - 1))
  }

  private def digitalSum(number: Int): Int = {
    number.toString.map(_.asDigit).sum
  }

  private def sievePrimes(limit: Int): Unit = {
    primes += 2
    val halfLimit = (limit + 1) / 2
    val composite = Array.fill(halfLimit)(false)
    var i = 1
    var p = 3
    while (i < halfLimit) {
      if (!composite(i)) {
        primes += p
        var a = i + p
        while (a < halfLimit) {
          composite(a) = true
          a += p
        }
      }
      i += 1
      p += 2
    }
  }

  private var honakerIndex = 0
  private var primeIndex = 0
  private val primes = ListBuffer[Int]()

  case class HonakerPrime(honakerIndex: Int, primeIndex: Int, prime: Int) {
    override def toString: String = s"($honakerIndex: $primeIndex, $prime)"
  }
}
