private fun nextPrimeDigitNumber(n: Int): Int {
    return if (n == 0) {
        2
    } else when (n % 10) {
        2 -> n + 1
        3, 5 -> n + 2
        else -> 2 + nextPrimeDigitNumber(n / 10) * 10
    }
}

private fun isPrime(n: Int): Boolean {
    if (n < 2) {
        return false
    }
    if (n and 1 == 0) {
        return n == 2
    }
    if (n % 3 == 0) {
        return n == 3
    }
    if (n % 5 == 0) {
        return n == 5
    }
    val wheel = intArrayOf(4, 2, 4, 2, 4, 6, 2, 6)
    var p = 7
    while (true) {
        for (w in wheel) {
            if (p * p > n) {
                return true
            }
            if (n % p == 0) {
                return false
            }
            p += w
        }
    }
}

private fun digitSum(n: Int): Int {
    var nn = n
    var sum = 0
    while (nn > 0) {
        sum += nn % 10
        nn /= 10
    }
    return sum
}

fun main() {
    val limit = 10000
    var p = 0
    var n = 0
    println("Extra primes under $limit:")
    while (p < limit) {
        p = nextPrimeDigitNumber(p)
        if (isPrime(p) && isPrime(digitSum(p))) {
            n++
            println("%2d: %d".format(n, p))
        }
    }
    println()
}
