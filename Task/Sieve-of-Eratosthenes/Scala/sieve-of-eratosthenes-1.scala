def sieveOfEratosthenes(nTo: Int) = {
  val primes = collection.mutable.BitSet.empty.par ++ (2 to nTo)
  for {
    candidate <- 2 until Math.sqrt(nTo).toInt
    if primes contains candidate
  } primes --= candidate * candidate to nTo by candidate
  primes
}
// An effect of parallel processing cause the result is shuffled.
println(sieveOfEratosthenes(101).toList.sorted)
