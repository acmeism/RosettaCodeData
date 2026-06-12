fun divisorSum(n: Long): Long {
    var nn = n
    var total = 1L
    var power = 2L
    // Deal with powers of 2 first
    while ((nn and 1) == 0L) {
        total += power

        power = power shl 1
        nn = nn shr 1
    }
    // Odd prime factors up to the square root
    var p = 3L
    while (p * p <= nn) {
        var sum = 1L
        power = p
        while (nn % p == 0L) {
            sum += power

            power *= p
            nn /= p
        }
        total *= sum

        p += 2
    }
    // If n > 1 then it's prime
    if (nn > 1) {
        total *= nn + 1
    }
    return total
}

fun main() {
    val limit = 100L
    println("Sum of divisors for the first $limit positive integers:")
    for (n in 1..limit) {
        print("%4d".format(divisorSum(n)))
        if (n % 10 == 0L) {
            println()
        }
    }
}
