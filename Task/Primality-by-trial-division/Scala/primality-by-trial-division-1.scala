  def isPrime(n: Int) = {
    assume(n <= Int.MaxValue - 1)
    n > 1 && (Iterator.from(2) takeWhile (d => d * d <= n) forall (n % _ != 0))
  }
