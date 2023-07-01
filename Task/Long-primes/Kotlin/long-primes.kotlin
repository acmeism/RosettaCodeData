// Version 1.2.60

fun sieve(limit: Int): List<Int> {
    val primes = mutableListOf<Int>()
    val c = BooleanArray(limit + 1)  // composite = true
    // no need to process even numbers
    var p = 3
    var p2 = p * p
    while (p2 <= limit) {
        for (i in p2..limit step 2 * p) c[i] = true
        do {
            p += 2
        } while (c[p])
        p2 = p * p
    }
    for (i in 3..limit step 2) {
        if (!c[i]) primes.add(i)
    }
    return primes
}

// finds the period of the reciprocal of n
fun findPeriod(n: Int): Int {
    var r = 1
    for (i in 1..n + 1) r = (10 * r) % n
    val rr = r
    var period = 0
    do {
        r = (10 * r) % n
        period++
    } while (r != rr)
    return period
}

fun main(args: Array<String>) {
    val primes = sieve(64000)
    val longPrimes = mutableListOf<Int>()
    for (prime in primes) {
        if (findPeriod(prime) == prime - 1) {
            longPrimes.add(prime)
        }
    }
    val numbers = listOf(500, 1000, 2000, 4000, 8000, 16000, 32000, 64000)
    var index = 0
    var count = 0
    val totals = IntArray(numbers.size)
    for (longPrime in longPrimes) {
        if (longPrime > numbers[index]) {
            totals[index++] = count
        }
        count++
    }
    totals[numbers.lastIndex] = count
    println("The long primes up to " + numbers[0] + " are:")
    println(longPrimes.take(totals[0]))

    println("\nThe number of long primes up to:")
    for ((i, total) in totals.withIndex()) {
        System.out.printf("  %5d is %d\n", numbers[i], total)
    }
}
