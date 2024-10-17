// version 1.1.2
// compiled with flag -Xcoroutines=enable to suppress 'experimental' warning

import kotlin.coroutines.experimental.*

typealias Transition = Pair<Int, Int>

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

fun main(args: Array<String>) {
    val primes = generatePrimes().take(1_000_000).toList()
    val transMap = mutableMapOf<Transition, Int>()
    for (i in 0 until primes.size - 1) {
        val transition = primes[i] % 10 to primes[i + 1] % 10
        if (transMap.containsKey(transition))
            transMap[transition] = transMap[transition]!! + 1
        else
            transMap.put(transition, 1)
    }
    val sortedTransitions = transMap.keys.sortedBy { it.second }.sortedBy { it.first }
    println("First 1,000,000 primes. Transitions prime % 10 -> next-prime % 10.")
    for (trans in sortedTransitions) {
        print("${trans.first} -> ${trans.second}  count: ${"%5d".format(transMap[trans])}")
        println("  frequency: ${"%4.2f".format(transMap[trans]!! / 10000.0)}%")
    }
}
