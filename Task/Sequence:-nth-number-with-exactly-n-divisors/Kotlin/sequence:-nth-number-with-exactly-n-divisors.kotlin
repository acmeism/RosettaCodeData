// Version 1.3.21

import java.math.BigInteger
import kotlin.math.sqrt

const val MAX = 33

fun isPrime(n: Int) = BigInteger.valueOf(n.toLong()).isProbablePrime(10)

fun generateSmallPrimes(n: Int): List<Int> {
    val primes = mutableListOf<Int>()
    primes.add(2)
    var i = 3
    while (primes.size < n) {
        if (isPrime(i)) {
            primes.add(i)
        }
        i += 2
    }
    return primes
}

fun countDivisors(n: Int): Int {
    var nn = n
    var count = 1
    while (nn % 2 == 0) {
        nn = nn shr 1
        count++
    }
    var d = 3
    while (d * d <= nn) {
        var q = nn / d
        var r = nn % d
        if (r == 0) {
            var dc = 0
            while (r == 0) {
                dc += count
                nn = q
                q = nn / d
                r = nn % d
            }
            count += dc
        }
        d += 2
    }
    if (nn != 1) count *= 2
    return count
}

fun main() {
    var primes = generateSmallPrimes(MAX)
    println("The first $MAX terms in the sequence are:")
    for (i in 1..MAX) {
        if (isPrime(i)) {
            var z = BigInteger.valueOf(primes[i - 1].toLong())
            z = z.pow(i - 1)
            System.out.printf("%2d : %d\n", i, z)
        } else {
            var count = 0
            var j = 1
            while (true) {
                if (i % 2 == 1) {
                    val sq = sqrt(j.toDouble()).toInt()
                    if (sq * sq != j) {
                        j++
                        continue
                    }
                }
                if (countDivisors(j) == i) {
                    if (++count == i) {
                        System.out.printf("%2d : %d\n", i, j)
                        break
                    }
                }
                j++
            }
        }
    }
}
