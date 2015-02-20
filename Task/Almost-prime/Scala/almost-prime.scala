def isKPrime(n: Int, k: Int, d: Int = 2): Boolean = (n, k, d) match {
    case (n, k, _) if n == 1 => k == 0
    case (n, _, d) if n % d == 0 => isKPrime(n / d, k - 1, d)
    case (_, _, _) => isKPrime(n, k, d + 1)
}

def kPrimeStream(k: Int): Stream[Int] = {
    def loop(n: Int): Stream[Int] =
        if (isKPrime(n, k)) n #:: loop(n+ 1)
        else loop(n + 1)
    loop(2)
}

for (k <- 1 to 5) {
    println( s"$k: [${ kPrimeStream(k).take(10) mkString " " }]" )
}
