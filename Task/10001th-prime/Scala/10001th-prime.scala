object Prime10001 extends App {

  val oddPrimes: LazyList[Int] = 3 #:: LazyList.from(5, 2)
        .filter(p => oddPrimes.takeWhile(_ <= math.sqrt(p)).forall(p % _ > 0))
  val primes = 2 #:: oddPrimes

  val index = 10_001
  println(s"prime($index): " + primes.drop(index - 1).head)
}
