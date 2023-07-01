object PrimeSum extends App {

  val oddPrimes: LazyList[Int] = 3 #:: LazyList.from(5, 2)
        .filter(p => oddPrimes.takeWhile(_ <= math.sqrt(p)).forall(p % _ > 0))
  val primes = 2 #:: oddPrimes

  def isPrime(n: Int): Boolean = {
    if (n < 5) (n | 1) == 3
    else primes.takeWhile(_ <= math.sqrt(n)).forall(n % _ > 0)
  }

  val limit = primes.takeWhile(_ <= 1000).length

  val number = (1 to limit).filter(index => {
        val list = primes.take(index)
        val sum = list.sum
        val flag = isPrime(sum)
        if (flag) println(f"$index%3d  ${list.last}%3d  $sum%5d")
        flag
      }).length

  println(s"\nfound $number such primes")
}
