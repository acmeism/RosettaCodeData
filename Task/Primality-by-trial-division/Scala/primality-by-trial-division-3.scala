import scala.annotation.tailrec
import scala.io.Source

object PrimesTestery extends App {
  val rawText = Source.fromURL("https://oeis.org/A000040/a000040.txt")
  val oeisPrimes = rawText.getLines().take(100000).map(_.split(" ")(1)).toVector

  def isPrime(n: Long) = {
    @tailrec
    def inner(d: Int, end: Int): Boolean = {
      if (d > end) true
      else if (n % d != 0 && n % (d + 2) != 0) inner(d + 6, end) else false
    }

    n > 1 && ((n & 1) != 0 || n == 2) &&
      (n % 3 != 0 || n == 3) && inner(5, math.sqrt(n).toInt)
  }

  println(oeisPrimes.size)
  for (i <- 0 to 1299709) assert(isPrime(i) == oeisPrimes.contains(i.toString), s"Wrong $i")

}
