def factorCount(num: Int): Int = Iterator.range(1, num/2 + 1).count(num%_ == 0) + 1
def antiPrimes: LazyList[Int] = LazyList.iterate((1: Int, 1: Int)){case (n, facs) => Iterator.from(n + 1).map(i => (i, factorCount(i))).dropWhile(_._2 <= facs).next}.map(_._1)
