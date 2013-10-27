  def isPrime(n: Long) = {
    n > 1 && ((n % 2 != 0) || (n == 2)) && ((3 until Math.sqrt(n).toInt by 2).par forall (n % _ != 0))
  }

  assert(isPrime(9223372036854775783L)) // Biggest 63-bit prime
  assert(!isPrime(Long.MaxValue))
