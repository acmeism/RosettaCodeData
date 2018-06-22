// version 1.1.51

import java.util.stream.Collectors

/* returns the number itself, its smallest prime factor and all its prime factors */
fun primeFactorInfo(n: Int): Triple<Int, Int, List<Int>> {
    if (n <= 1) throw IllegalArgumentException("Number must be more than one")
    if (isPrime(n)) return Triple(n, n, listOf(n))
    val factors = mutableListOf<Int>()
    var factor = 2
    var nn = n
    while (true) {
        if (nn % factor == 0) {
            factors.add(factor)
            nn /= factor
            if (nn == 1) return Triple(n, factors.min()!!, factors)
            if (isPrime(nn)) factor = nn
        }
        else if (factor >= 3) factor += 2
        else factor = 3
    }
}

fun isPrime(n: Int) : Boolean {
    if (n < 2) return false
    if (n % 2 == 0) return n == 2
    if (n % 3 == 0) return n == 3
    var d = 5
    while (d * d <= n) {
        if (n % d == 0) return false
        d += 2
        if (n % d == 0) return false
        d += 4
    }
    return true
}

fun main(args: Array<String>) {
    val numbers = listOf(
        12757923, 12878611, 12878893, 12757923, 15808973, 15780709, 197622519
    )
    val info = numbers.stream()
                      .parallel()
                      .map { primeFactorInfo(it) }
                      .collect(Collectors.toList())
    val maxFactor = info.maxBy { it.second }!!.second
    val results = info.filter { it.second == maxFactor }
    println("The following number(s) have the largest minimal prime factor of $maxFactor:")
    for (result in results) {
        println("  ${result.first} whose prime factors are ${result.third}")
    }
}
