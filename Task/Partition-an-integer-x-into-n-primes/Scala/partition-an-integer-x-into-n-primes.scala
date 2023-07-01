object PartitionInteger {

  def sieve(nums: LazyList[Int]): LazyList[Int] =
    LazyList.cons(nums.head, sieve((nums.tail) filter (_ % nums.head != 0)))

  // An 'infinite' stream of primes, lazy evaluation and memo-ized
  private val oddPrimes = sieve(LazyList.from(3, 2))
  private val primes = sieve(2 #:: oddPrimes).take(3600 /*50_000*/)

  private def findCombo(k: Int, x: Int, m: Int, n: Int, combo: Array[Int]): Boolean = {
    var foundCombo = combo.map(i => primes(i)).sum == x
    if (k >= m) {
      if (foundCombo) {
        val s: String = if (m > 1) "s" else ""
        printf("Partitioned %5d with %2d prime%s: ", x, m, s)
        for (i <- 0 until m) {
          print(primes(combo(i)))
          if (i < m - 1) print('+') else println()
        }
      }
    } else for (j <- 0 until n if k == 0 || j > combo(k - 1)) {
      combo(k) = j
      if (!foundCombo) foundCombo = findCombo(k + 1, x, m, n, combo)
    }
    foundCombo
  }

  private def partition(x: Int, m: Int): Unit = {
    val n: Int = primes.count(it => it <= x)
    if (n < m) throw new IllegalArgumentException("Not enough primes")

    if (!findCombo(0, x, m, n, new Array[Int](m)))
      printf("Partitioned %5d with %2d prime%s: (not possible)\n", x, m, if (m > 1) "s" else " ")
  }

  def main(args: Array[String]): Unit = {
    partition(99809, 1)
    partition(18, 2)
    partition(19, 3)
    partition(20, 4)
    partition(2017, 24)
    partition(22699, 1)
    partition(22699, 2)
    partition(22699, 3)
    partition(22699, 4)
    partition(40355, 3)
  }

}
