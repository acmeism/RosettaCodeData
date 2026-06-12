val primes3 = 3 #:: LazyList.from(5, 6)
    .flatMap(p => Iterator(p, p + 2))
    .filter(p => (5 to math.sqrt(p).floor.toInt by 6).forall(a => p % a > 0 && p % (a + 2) > 0))

def merge(sort1: Seq[Int], sort2: Seq[Int]): Seq[Int] = {
  def iter(sort1: Seq[Int], sort2: Seq[Int], acc: Seq[Int]): Seq[Int] = {
    if (sort1.isEmpty) return acc ++ sort2
    val (x, y) = (sort1.head, sort2.head)
    val (min, s1, s2) = if (x < y) (x, sort1.tail, sort2)
          else (y, sort2.tail, sort1)
    iter(s1, s2, acc :+ min)
  }
  iter(sort1, sort2, Seq())
}

def semiPrimes(limit: Int): Seq[Int] = { // odd, squarefree generator
  def iter(primeList: Seq[Int], acc: Seq[Int]): Seq[Int] = {
    val (start, primeList1) = (primeList.head, primeList.tail)
    val subList = primeList1.map(_ * start).takeWhile(_ <= limit)
    if (subList.isEmpty) return acc
    iter(primeList1, merge(acc, subList))
  }
  iter(primes3, Seq())
}

@main def main = {
  val start = System.currentTimeMillis
  val spList = semiPrimes(1000)
  val duration = System.currentTimeMillis - start
  spList.grouped(20).foreach(group =>
      group.foreach(sp => print(f"$sp%3d "))
      println
    )
  println(s"number: ${spList.length} [time elapsed: $duration ms]")
}
