// version 1.2.60

fun isPrime(n: Long): Boolean {
    if (n % 2L == 0L) return n == 2L
    if (n % 3L == 0L) return n == 3L
    var d = 5L
    while (d * d <= n) {
        if (n % d == 0L) return false
        d += 2L
        if (n % d == 0L) return false
        d += 4L
    }
    return true
}

tailrec fun loop(index: Long, numPrimes: Int) {
    if (numPrimes == 42) return
    var i = index
    var n = numPrimes
    if (isPrime(i)) {
        n++
        System.out.printf("n = %-2d  %,19d\n", n, i)
        loop(2 * i - 1, n)
    }
    else loop(++i, n)
}

fun main(args: Array<String>) {
    loop(42, 0)
}
