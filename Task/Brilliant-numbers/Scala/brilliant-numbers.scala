val primes = 2 #:: LazyList.from(3, 2)    // simple prime
    .filter(p => (3 to math.sqrt(p).ceil.toInt by 2).forall(p % _ > 0))

def brilliantSemiPrimes(limit: Int): Seq[Int] = {
  def iter(primeList: LazyList[Int], bLimit: Int, acc: Seq[Int]): Seq[Int] = {
    val (start, tail) = (primeList.head, primeList.tail)
    val brilliants = primeList
            .takeWhile(_ <= bLimit)
            .map(_ * start)
            .takeWhile(_ <= limit)
    if (brilliants.isEmpty) return acc
    val bLimit1 = if (tail.head > bLimit) 10 * bLimit else bLimit
    iter(tail, bLimit1, brilliants.toSeq ++ acc)
  }
  iter(primes, 10, Seq()).sorted
}

@main def main = {
  val start = System.currentTimeMillis
  val brList = brilliantSemiPrimes(1500).take(100)
  val duration = System.currentTimeMillis - start
  for (group <- brList.grouped(20))
      println(group.map("%4d".format(_)).mkString(" "))
  println(s"time elapsed: $duration ms\n")

  for (limit <- (1 to 6).map(math.pow(10,_).toInt)) {
    val start = System.currentTimeMillis
    val (bril, index) = brilliantSemiPrimes((limit * 1.25).toInt)
            .zipWithIndex
            .dropWhile((b, _i) => b < limit)
            .take(1).head
    val duration = System.currentTimeMillis - start
    println(f"first >= $limit%7d is $bril%7d at position ${index+1}%5d [time(ms) $duration%2d]")
  }
}
