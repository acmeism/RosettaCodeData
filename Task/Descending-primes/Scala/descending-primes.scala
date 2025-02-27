def isPrime(n: Long): Boolean = {
  @annotation.tailrec
  def hasDivisor(f: Long): Boolean =
    if (f * f > n) false
    else if (n % f == 0 || n % (f + 2) == 0) true
    else hasDivisor(f + 6)

  if (n < 2) false
  else if (n == 2 || n == 3) true
  else if (n % 2 == 0 || n % 3 == 0) false
  else {
    !hasDivisor(5)
  }
}

def descendingPrimes(): Seq[Int] = {
  val digits = Seq(9, 8, 7, 6, 5, 4, 3, 2, 1)

  val (_, primes) = digits.foldLeft((Seq(0), Seq.empty[Int])) { case ((candidates, primes), digit) =>
    val newCandidates = candidates.map(_ * 10 + digit)
    val newPrimes = primes ++ newCandidates.filter(isPrime)
    (candidates ++ newCandidates, newPrimes)
  }

  primes.sorted
}

@main def main(): Unit = {
  def test(): Unit = {
    val primes = descendingPrimes()

    val maxDigits = primes.map(_.toString.length).max
    val columnsPerLine = 8
    val groupedPrimes = primes.grouped(columnsPerLine)
    groupedPrimes.foreach { group =>
      val formattedGroup = group.map(p => String.format(s"%${maxDigits}d", Int.box(p))).mkString("  ")
      println(formattedGroup)
    }
  }

  test()
}
