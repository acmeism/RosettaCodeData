// Version 1.3.21

fun chowla(n: Int): Int {
    if (n < 1) throw RuntimeException("argument must be a positive integer")
    var sum = 0
    var i = 2
    while (i * i <= n) {
        if (n % i == 0) {
            val j = n / i
            sum += if (i == j) i else i + j
        }
        i++
    }
    return sum
}

fun sieve(limit: Int): BooleanArray {
    // True denotes composite, false denotes prime.
    // Only interested in odd numbers >= 3
    val c = BooleanArray(limit)
    for (i in 3 until limit / 3 step 2) {
        if (!c[i] && chowla(i) == 0) {
            for (j in 3 * i until limit step 2 * i) c[j] = true
        }
    }
    return c
}

fun main() {
    for (i in 1..37) {
        System.out.printf("chowla(%2d) = %d\n", i, chowla(i))
    }
    println()

    var count = 1
    var limit = 10_000_000
    val c = sieve(limit)
    var power = 100
    for (i in 3 until limit step 2) {
        if (!c[i]) count++
        if (i == power - 1) {
            System.out.printf("Count of primes up to %,-10d = %,d\n", power, count)
            power *= 10
        }
    }

    println()
    count = 0
    limit = 35_000_000
    var i = 2
    while (true) {
        val p = (1 shl (i - 1)) * ((1 shl i) - 1) // perfect numbers must be of this form
        if (p > limit) break
        if (chowla(p) == p - 1) {
            System.out.printf("%,d is a perfect number\n", p)
            count++
        }
        i++
    }
    println("There are $count perfect numbers <= 35,000,000")
}
