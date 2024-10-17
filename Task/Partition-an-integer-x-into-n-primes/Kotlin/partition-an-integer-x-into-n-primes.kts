// version 1.1.2

// compiled with flag -Xcoroutines=enable to suppress 'experimental' warning

import kotlin.coroutines.experimental.*

val primes = generatePrimes().take(50_000).toList()  // generate first 50,000 say
var foundCombo = false

fun isPrime(n: Int) : Boolean {
    if (n < 2) return false
    if (n % 2 == 0) return n == 2
    if (n % 3 == 0) return n == 3
    var d : Int = 5
    while (d * d <= n) {
        if (n % d == 0) return false
        d += 2
        if (n % d == 0) return false
        d += 4
    }
    return true
}

fun generatePrimes() =
    buildSequence {
        yield(2)
        var p = 3
        while (p <= Int.MAX_VALUE) {
           if (isPrime(p)) yield(p)
           p += 2
        }
    }

fun findCombo(k: Int, x: Int, m: Int, n: Int, combo: IntArray) {
    if (k >= m) {
        if (combo.sumBy { primes[it] } == x) {
           val s = if (m > 1) "s" else " "
           print("Partitioned ${"%5d".format(x)} with ${"%2d".format(m)} prime$s: ")
           for (i in 0 until m) {
               print(primes[combo[i]])
               if (i < m - 1) print("+") else println()
           }
           foundCombo = true
        }
    }
    else {
        for (j in 0 until n) {
            if (k == 0 || j > combo[k - 1]) {
                combo[k] = j
                if (!foundCombo) findCombo(k + 1, x, m, n, combo)
            }
        }
    }
}

fun partition(x: Int, m: Int) {
    require(x >= 2 && m >= 1 && m < x)
    val filteredPrimes = primes.filter { it <= x }
    val n = filteredPrimes.size
    if (n < m) throw IllegalArgumentException("Not enough primes")
    val combo = IntArray(m)
    foundCombo = false
    findCombo(0, x, m, n, combo)
    if (!foundCombo) {
        val s = if (m > 1) "s" else " "
        println("Partitioned ${"%5d".format(x)} with ${"%2d".format(m)} prime$s: (not possible)")
    }
}

fun main(args: Array<String>) {
    val a = arrayOf(
        99809 to 1,
        18 to 2,
        19 to 3,
        20 to 4,
        2017 to 24,
        22699 to 1,
        22699 to 2,
        22699 to 3,
        22699 to 4,
        40355 to 3
    )
    for (p in a) partition(p.first, p.second)
}
