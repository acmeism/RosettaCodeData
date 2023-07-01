// Version 1.3.21

fun totient(n: Int): Int {
    var tot = n
    var nn = n
    var i = 2
    while (i * i <= nn) {
        if (nn % i == 0) {
            while (nn % i == 0) nn /= i
            tot -= tot / i
        }
        if (i == 2) i = 1
        i += 2
    }
    if (nn > 1) tot -= tot / nn
    return tot
}

fun main() {
    println(" n  phi   prime")
    println("---------------")
    var count = 0
    for (n in 1..25) {
        val tot = totient(n)
        val isPrime  = n - 1 == tot
        if (isPrime) count++
        System.out.printf("%2d   %2d   %b\n", n, tot, isPrime)
    }
    println("\nNumber of primes up to 25     = $count")
    for (n in 26..100_000) {
        val tot = totient(n)
        if (tot == n-1) count++
        if (n == 100 || n == 1000 || n % 10_000 == 0) {
            System.out.printf("\nNumber of primes up to %-6d = %d\n", n, count)
        }
    }
}
