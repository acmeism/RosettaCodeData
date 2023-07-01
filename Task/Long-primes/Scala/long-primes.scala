object LongPrimes extends App {
    def primeStream = LazyList.from(3, 2)
        .filter(p => (3 to math.sqrt(p).ceil.toInt by 2).forall(p % _ > 0))

    def longPeriod(p: Int): Boolean = {
        val mstart = 10 % p
        @annotation.tailrec
        def iter(mod: Int, period: Int): Int = {
            val mod1 = (10 * mod) % p
            if (mod1 == mstart) period
            else iter(mod1, period + 1)
        }
        iter(mstart, 1) == p - 1
    }

    val longPrimes = primeStream.filter(longPeriod(_))
    println("long primes up to 500:")
    println(longPrimes.takeWhile(_ <= 500).mkString(" "))
    println

    val limitList = Seq.tabulate(8)(math.pow(2, _).toInt * 500)
    for (limit <- limitList) {
        val count = longPrimes.takeWhile(_ <= limit).length
        println(f"there are $count%4d long primes up to $limit%5d")
    }
}
