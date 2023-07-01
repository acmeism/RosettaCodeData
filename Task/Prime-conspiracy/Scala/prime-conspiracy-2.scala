object PrimeConspiracy1 extends App {
  private val oddPrimes: Stream[Int] =
    3 #:: Stream.from(5, 2)
      .filter(n => oddPrimes.takeWhile(k => k * k <= n).forall(d => n % d != 0))
  val limit = 1000000

  println(s"Population: $limit primes,")
  println(s"Last considered prime ${oddPrimes(limit - 2)}")
  val lsd = oddPrimes.take(limit).par.map(_ % 10)

  val results: Seq[(((Int, Int), Int), Int)] =
    (2 +: lsd).zip(lsd)
      .groupBy(identity).map { case (k, v) => (k, v.size) }
      .toList.sortBy { case ((_, _), n) => -n }.zipWithIndex // Add ranking
      .sorted

  results.foreach { case (((i, j), nPrime), rank) =>
    println(f"$i%d -> $j%d : $nPrime%5d  ${nPrime / (limit / 100.0)}%2f rank:${rank + 1}%3d")
  }
  // println(results.map { case (((_, _), n), _) => n }.sum)

  println(s"Successfully completed without errors. [total ${scala.compat.Platform.currentTime - executionStart} ms]")
}
