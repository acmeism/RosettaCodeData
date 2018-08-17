object IsPrimeTrialDivision extends App {
  def isPrime(n: Long) =
    n > 1 && ((n & 1) != 0 || n == 2) && (n % 3 != 0 || n == 3) &&
      (5 to math.sqrt(n).toInt by 6).par.forall(d => n % d != 0 && n % (d + 2) != 0)

  assert(!isPrime(-1))
  assert(!isPrime(1))
  assert(isPrime(2))
  assert(isPrime(100000000003L))
  assert(isPrime(100000000019L))
  assert(isPrime(100000000057L))
  assert(isPrime(100000000063L))
  assert(isPrime(100000000069L))
  assert(isPrime(100000000073L))
  assert(isPrime(100000000091L))
  println("10 Numbers tested. A moment please …\nNumber crunching biggest 63-bit prime …")
  assert(isPrime(9223372036854775783L)) // Biggest 63-bit prime
  println("All done")

}
