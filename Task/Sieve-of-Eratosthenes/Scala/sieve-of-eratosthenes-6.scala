object MainSoEPagedOdds extends App {
  import APFSoEPagedOdds._
  countSoEPrimesTo(100)
  val top = 1000000000
  val strt = System.currentTimeMillis()
  val cnt = enumSoEPrimes().takeWhile { _ <= top }.length
//  val cnt = countSoEPrimesTo(top)
  val elpsd = System.currentTimeMillis() - strt
  println(f"Found $cnt primes up to $top in $elpsd milliseconds.")
}
