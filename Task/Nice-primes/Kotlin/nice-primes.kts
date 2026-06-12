fun isPrime(n: Long): Boolean {
    if (n < 2) {
        return false
    }
    if (n % 2 == 0L) {
        return n == 2L
    }
    if (n % 3 == 0L) {
        return n == 3L
    }

    var p = 5
    while (p * p <= n) {
        if (n % p == 0L) {
            return false
        }
        p += 2
        if (n % p == 0L) {
            return false
        }
        p += 4
    }
    return true
}

fun digitalRoot(n: Long): Long {
    if (n == 0L) {
        return 0
    }
    return 1 + (n - 1) % 9
}

fun main() {
    val from = 500L
    val to = 1000L
    var count = 0

    println("Nice primes between $from and $to:")
    var n = from
    while (n < to) {
        if (isPrime(digitalRoot(n)) && isPrime(n)) {
            count += 1
            print(n)
            if (count % 10 == 0) {
                println()
            } else {
                print(' ')
            }
        }

        n += 1
    }
    println()
    println("$count nice primes found.")
}
