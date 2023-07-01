private fun sieve(limit: Int): Array<Int> {
    val primes = mutableListOf<Int>()
    primes.add(2)
    val c = BooleanArray(limit + 1) // composite = true
    // no need to process even numbers > 2
    var p = 3
    while (true) {
        val p2 = p * p
        if (p2 > limit) {
            break
        }
        var i = p2
        while (i <= limit) {
            c[i] = true
            i += 2 * p
        }
        do {
            p += 2
        } while (c[p])
    }
    var i = 3
    while (i <= limit) {
        if (!c[i]) {
            primes.add(i)
        }
        i += 2
    }
    return primes.toTypedArray()
}

private fun successivePrimes(primes: Array<Int>, diffs: Array<Int>): List<List<Int>> {
    val results = mutableListOf<List<Int>>()
    val dl = diffs.size
    outer@ for (i in 0 until primes.size - dl) {
        val group = IntArray(dl + 1)
        group[0] = primes[i]
        for (j in i until i + dl) {
            if (primes[j + 1] - primes[j] != diffs[j - i]) {
                continue@outer
            }
            group[j - i + 1] = primes[j + 1]
        }
        results.add(group.toList())
    }
    return results
}

fun main() {
    val primes = sieve(999999)
    val diffsList = arrayOf(
        arrayOf(2),
        arrayOf(1),
        arrayOf(2, 2),
        arrayOf(2, 4),
        arrayOf(4, 2),
        arrayOf(6, 4, 2)
    )
    println("For primes less than 1,000,000:-\n")
    for (diffs in diffsList) {
        println("  For differences of ${diffs.contentToString()} ->")
        val sp = successivePrimes(primes, diffs)
        if (sp.isEmpty()) {
            println("    No groups found")
            continue
        }
        println("    First group   = ${sp[0].toTypedArray().contentToString()}")
        println("    Last group    = ${sp[sp.size - 1].toTypedArray().contentToString()}")
        println("    Number found  = ${sp.size}")
        println()
    }
}
