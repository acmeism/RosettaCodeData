class PrimeFactors(n: BigInt) extends Iterator[BigInt] {
  val zero = BigInt(0)
  val one = BigInt(1)
  val two = BigInt(2)
  def isPrime(n: BigInt) = n.isProbablePrime(10)
  var currentN = n
  var prime = two

  def nextPrime =
    if (prime == two) {
      prime += one
    } else {
      prime += two
      while (!isPrime(prime)) {
        prime += two
        if (prime * prime > currentN)
          prime = currentN
      }
    }

  def next = {
    if (!hasNext)
      throw new NoSuchElementException("next on empty iterator")

    while(currentN % prime != zero) {
      nextPrime
    }
    currentN /= prime
    prime
  }

  def hasNext = currentN != one && currentN > zero
}
