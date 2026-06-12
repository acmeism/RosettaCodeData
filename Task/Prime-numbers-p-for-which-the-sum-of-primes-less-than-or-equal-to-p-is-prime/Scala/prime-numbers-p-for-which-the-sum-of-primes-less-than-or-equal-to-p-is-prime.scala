def primeStream3 = Iterator.from(3, 2).filter(isPrime(_))

val primes = LazyList(2) ++ primeStream3

def isPrime(n: Int): Boolean =
    if (n < 5) (n | 1) == 3
    else primes.takeWhile(_ <= math.sqrt(n)).forall(n % _ > 0)

lazy val psumList = {
    def loop(p: LazyList[Int], sum: Int): LazyList[(Int, Int)] = {
        val sum1 = p.head + sum
        (p.head, sum1) #:: loop(p.tail, sum1)
    }
    loop(primes, 0)
}

@main
def main = {
    val limit = 2_000
    val primeSums = psumList.flatMap((p, s) =>
            if (isPrime(s)) Some(p) else None
        ).takeWhile(_ <= limit)
    val fmtStr = "%%%dd".format(primeSums.last.toString.length)
    for (group <- primeSums.grouped(10))
        println(group.map(fmtStr.format(_)).mkString(" "))
} // © 2025
