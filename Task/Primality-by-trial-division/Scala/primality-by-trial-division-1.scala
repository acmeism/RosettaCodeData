  def isPrime(n: Int) =
    n > 1 && (Iterator.from(2) takeWhile (d => d * d <= n) forall (n % _ != 0))
