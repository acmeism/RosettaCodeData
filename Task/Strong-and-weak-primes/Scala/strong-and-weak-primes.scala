object StrongWeakPrimes {
  def main(args: Array[String]): Unit = {
    val bnd = 1000000
    println(
      f"""|First 36 Strong Primes: ${strongPrimes.take(36).map(n => f"$n%,d").mkString(", ")}
          |Strong Primes < 1,000,000: ${strongPrimes.takeWhile(_ < bnd).size}%,d
          |Strong Primes < 10,000,000: ${strongPrimes.takeWhile(_ < 10*bnd).size}%,d
          |
          |First 37 Weak Primes: ${weakPrimes.take(37).map(n => f"$n%,d").mkString(", ")}
          |Weak Primes < 1,000,000: ${weakPrimes.takeWhile(_ < bnd).size}%,d
          |Weak Primes < 10,000,000: ${weakPrimes.takeWhile(_ < 10*bnd).size}%,d""".stripMargin)
  }

  def weakPrimes: LazyList[Int] = primeTrips.filter{case a +: b +: c +: _ => b < (a + c)/2.0}.map(_(1)).to(LazyList)
  def strongPrimes: LazyList[Int] = primeTrips.filter{case a +: b +: c +: _ => b > (a + c)/2}.map(_(1)).to(LazyList)
  def primeTrips: Iterator[LazyList[Int]] = primes.sliding(3)
  def primes: LazyList[Int] = 2 #:: LazyList.from(3, 2).filter(n => !Iterator.range(3, math.sqrt(n).toInt + 1, 2).exists(n%_ == 0))
}
