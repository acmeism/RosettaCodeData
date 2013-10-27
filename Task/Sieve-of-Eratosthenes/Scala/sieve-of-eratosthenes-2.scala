  import scala.annotation.tailrec

  /*
   * Sieve of primes: returns all primes between 2 and nTo including.
   */
  def sieve(nTo: Int): Seq[Int] = {
    @tailrec
    def inner(i: Int, primes: Seq[Int]): Seq[Int] = {
      if (i > nTo) primes
      else {
        if (primes exists (i % _ == 0)) inner(i + 2, primes)
        else inner(i + 2, primes :+ i)
      }
    }
    if (nTo < 2) Seq.empty else inner(3, Seq(2))
  }

  // Print the resulting list in a table.
  val lineLength = 30
  for (l <- 0 to 599 by lineLength) {
    @tailrec
    def inner(primes: Seq[Int], pos: Int, endPos: Int, acc: String): String =
      {
        if (pos >= endPos) acc
        else inner(primes, pos + 1, endPos,
          acc + (if (primes contains pos) f"$pos%3d" else f"${'.'}%3s"))
      }

    println(inner(sieve(599), l, l + lineLength, ""))
  }
