def sieveOfEratosthenes(nTo: Int) = {
  val primes = collection.mutable.BitSet.empty.par ++ (2 +: (3 to nTo by 2))
  for {
    candidate <- 3 until Math.sqrt(nTo).toInt
    if primes contains candidate
  } primes --= candidate * candidate to nTo by candidate
  primes
}
// BitSet toList is shuffled.
println(sieveOfEratosthenes(101).toList.sorted)
