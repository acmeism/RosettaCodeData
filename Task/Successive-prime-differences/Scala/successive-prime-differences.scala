object SuccessivePrimeDiffs {
  def main(args: Array[String]): Unit = {
    val d2 = primesByDiffs(2)(1000000)
    val d1 = primesByDiffs(1)(1000000)
    val d22 = primesByDiffs(2, 2)(1000000)
    val d24 = primesByDiffs(2, 4)(1000000)
    val d42 = primesByDiffs(4, 2)(1000000)
    val d642 = primesByDiffs(6, 4, 2)(1000000)

    if(true) println(
      s"""|Diffs: (First), (Last), Count
          |2:     (${d2.head.mkString(", ")}), (${d2.last.mkString(", ")}), ${d2.size}
          |1:     (${d1.head.mkString(", ")}), (${d1.last.mkString(", ")}), ${d1.size}
          |2-2:   (${d22.head.mkString(", ")}), (${d22.last.mkString(", ")}), ${d22.size}
          |2-4:   (${d24.head.mkString(", ")}), (${d24.last.mkString(", ")}), ${d24.size}
          |4-2:   (${d42.head.mkString(", ")}), (${d42.last.mkString(", ")}), ${d42.size}
          |6-4-2: (${d642.head.mkString(", ")}), (${d642.last.mkString(", ")}), ${d642.size}
          |""".stripMargin)
  }

  def primesByDiffs(diffs: Int*)(max: Int): LazyList[Vector[Int]] = {
    primesSliding(diffs.size + 1)
      .takeWhile(_.last <= max)
      .filter{vec => diffs.zip(vec.init).map{case (a, b) => a + b} == vec.tail}
      .to(LazyList)
  }

  def primesSliding(len: Int): Iterator[Vector[Int]] = primes.sliding(len).map(_.toVector)
  def primes: LazyList[Int] = 2 #:: LazyList.from(3, 2).filter(n => !Iterator.range(3, math.sqrt(n).toInt + 1, 2).exists(n%_ == 0))
}
