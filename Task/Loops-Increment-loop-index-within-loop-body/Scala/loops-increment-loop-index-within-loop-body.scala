import scala.annotation.tailrec

object LoopIncrementWithinBody extends App {
  private val (limit, offset) = (42L, 1)

  @tailrec
  private def loop(i: Long, n: Int): Unit = {

    def isPrime(n: Long) =
      n > 1 && ((n & 1) != 0 || n == 2) && (n % 3 != 0 || n == 3) &&
        ((5 to math.sqrt(n).toInt by 2).par forall (n % _ != 0))

    if (n < limit + offset)
      if (isPrime(i)) {
        printf("n = %-2d  %,19d%n".formatLocal(java.util.Locale.GERMANY, n, i))
        loop(i + i + 1, n + 1)
      } else loop(i + 1, n)
  }

  loop(limit, offset)
}
