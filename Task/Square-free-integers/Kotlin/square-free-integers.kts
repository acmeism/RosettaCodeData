// Version 1.2.50

import kotlin.math.sqrt

fun sieve(limit: Long): List<Long> {
    val primes = mutableListOf(2L)
    val c = BooleanArray(limit.toInt() + 1) // composite = true
    // no need to process even numbers > 2
    var p = 3
    while (true) {
        val p2 = p * p
        if (p2 > limit) break
        for (i in p2..limit step 2L * p) c[i.toInt()] = true
        do { p += 2 } while (c[p])
    }
    for (i in 3..limit step 2)
        if (!c[i.toInt()])
            primes.add(i)

    return primes
}

fun squareFree(r: LongProgression): List<Long> {
    val primes = sieve(sqrt(r.last.toDouble()).toLong())
    val results = mutableListOf<Long>()
    outer@ for (i in r) {
        for (p in primes) {
            val p2 = p * p
            if (p2 > i) break
            if (i % p2 == 0L) continue@outer
        }
        results.add(i)
    }
    return results
}

fun printResults(r: LongProgression, c: Int, f: Int) {
    println("Square-free integers from ${r.first} to ${r.last}:")
    squareFree(r).chunked(c).forEach {
        println()
        it.forEach { print("%${f}d".format(it)) }
    }
    println('\n')
}

const val TRILLION = 1000000_000000L

fun main(args: Array<String>) {
    printResults(1..145L, 20, 4)
    printResults(TRILLION..TRILLION + 145L, 5, 14)

    println("Number of square-free integers:\n")
    longArrayOf(100, 1000, 10000, 100000, 1000000).forEach {
        j -> println("  from 1 to $j = ${squareFree(1..j).size}")
    }
}
