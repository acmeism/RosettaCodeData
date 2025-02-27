import java.util.BitSet
import java.util.TreeMap
import kotlin.math.sqrt

class Radicals(val limit: Int) {
    val primes: List<Int>
    val radicals: IntArray // valid indices: 1..limit
    val distinctPrimeFactorCounts: IntArray // valid indices: 2..limit
    val distinctPrimeFactorCountDistribution: Map<Int, Int>

    init {
        // Sieve
        val composites = BitSet()
        for (i in 2..sqrt(limit.toDouble()).toInt()) {
            if (!composites[i]) {
                for (j in i * i..limit step i) composites.set(j)
            }
        }
        primes = (2..limit).filterNot(composites::get)

        // Calculate radicals and distinct prime factor counts
        distinctPrimeFactorCounts = IntArray(limit + 1) { 0 }
        radicals = IntArray(limit + 1) { 1 }
        for (p in primes) {
            for (i in p..limit step p) {
                distinctPrimeFactorCounts[i]++
                radicals[i] *= p
            }
        }

        distinctPrimeFactorCountDistribution =
            distinctPrimeFactorCounts.asList()
                .subList(2, distinctPrimeFactorCounts.size)
                .groupingBy { it }
                .eachCountTo(TreeMap())
    }
}

fun main() {
    with(Radicals(limit = 1_000_000)) {
        println("Radicals of first 50 positive integers:")
        for (i in 1..41 step 10) {
            println((i..i + 9).joinToString(separator = " ") { "%2d".format(radicals[it]) })
        }
        println()

        for (n in listOf(99_999, 499_999, 999_999)) {
            println("Radical for %6d: %6d".format(n, radicals[n]))
        }
        println()

        println("Distribution of the first $limit positive integers by numbers of distinct prime factors:")
        for ((i, count) in distinctPrimeFactorCountDistribution) {
            println("%d: %6d".format(i, count))
        }
        println()

        println("Number of primes and powers of primes less than or equal to $limit:")
        val count = primes.sumOf { prime ->
            generateSequence(limit) { it / prime }.takeWhile { it >= prime }.count()
        }
        println(count)
    }
}
