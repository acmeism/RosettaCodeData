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

fun main(args: Array<String>) {
    var i = 42L
    var n = 0
    do {
        if (isPrime(i)) {
            n++
            System.out.printf("n = %-2d  %,19d\n", n, i)
            i += i - 1
        }
        i++
    }
    while (n < 42)
}
