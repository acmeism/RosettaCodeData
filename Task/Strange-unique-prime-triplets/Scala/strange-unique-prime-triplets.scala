val primeStream5 = LazyList.from(5, 6)
    .flatMap(n => Seq(n, n + 2))
    .filter(p => (5 to math.sqrt(p).floor.toInt by 6).forall(a => p % a > 0 && p % (a + 2) > 0))

val primes = LazyList(2, 3) ++ primeStream5

def isPrime(n: Int): Boolean =
    if (n < 5) (n | 1) == 3
    else primes.takeWhile(_ <= math.sqrt(n)).forall(n % _ > 0)

def triplets(limit: Int): Iterator[Seq[Int]] =
    primes.takeWhile(_ <= limit)
        .combinations{3}
        .filter(primeTriplet => isPrime(primeTriplet.sum))

@main def main: Unit = {
    for (list <- triplets(30)) {
        val Seq(k, l, m) = list
        println(f"$k%2d + $l%2d + $m%2d = ${list.sum}%2d")
    }

    for (limit <- Seq(30, 1000)) {
        val start = System.currentTimeMillis
        val num = triplets(limit).length
        val duration = System.currentTimeMillis - start
        println(f"number of prime triplets up to $limit%4d is $num%6d [time(ms): $duration%4d]")
    }
}
