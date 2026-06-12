def primeStream3 = Iterator.from(3, 2)
    .filter(p => (3 to math.sqrt(p).floor.toInt by 2).forall(p % _ > 0))

val primes = LazyList(2) ++ primeStream3

def isPrime(n: Long): Boolean =
    if (n < 5) (n | 1) == 3
    else primes.takeWhile(_ <= math.sqrt(n.toDouble)).forall(n % _ > 0)

def primeProd(limit: Int): Iterator[Seq[Long]] =
    primes.takeWhile(_ <= limit)
        .map(_.toLong)
        .sliding(2)
        .filter(pair => isPrime(pair.product + 2))

@main
def main = {
    for (group <- primeProd(500).grouped(10)) {
        val grpLst = group.map(seq => s"[${seq.mkString(",")}]")
        println(grpLst.map("%9s".format(_)).mkString(" "))
    }

    for (limit <- Seq(500, 100_000)) {
        val start = System.currentTimeMillis
        val num = primeProd(limit).length
        val duration = System.currentTimeMillis - start
        println(f"number of neighbour primes up to $limit%6d is $num%3d [time(ms): $duration%3d]")
    }
} //© 2025
