import kotlin.math.pow

private fun divisorCount(n: Long): Long {
    var nn = n
    var total: Long = 1
    // Deal with powers of 2 first
    while (nn and 1 == 0L) {
        ++total
        nn = nn shr 1
    }
    // Odd prime factors up to the square root
    var p: Long = 3
    while (p * p <= nn) {
        var count = 1L
        while (nn % p == 0L) {
            ++count
            nn /= p
        }
        total *= count
        p += 2
    }
    // If n > 1 then it's prime
    if (nn > 1) {
        total *= 2
    }
    return total
}

private fun divisorProduct(n: Long): Long {
    return n.toDouble().pow(divisorCount(n) / 2.0).toLong()
}

fun main() {
    val limit: Long = 50
    println("Product of divisors for the first $limit positive integers:")
    for (n in 1..limit) {
        print("%11d".format(divisorProduct(n)))
        if (n % 5 == 0L) {
            println()
        }
    }
}
