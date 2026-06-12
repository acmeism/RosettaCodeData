// version 1.2.10

import java.math.BigInteger

const val MAX = 20

val bigOne = BigInteger.ONE
val bigTwo = 2.toBigInteger()

/* for checking 'small' primes */
fun isPrime(n: Int): Boolean {
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

fun main(args: Array<String>) {
    var count = 0
    var p = 2
    while (true) {
        val m = (bigTwo shl (p - 1)) - bigOne
        if (m.isProbablePrime(10)) {
            println("2 ^ $p - 1")
            if (++count == MAX) break
        }
        // obtain next prime, p
        while(true) {
            p = if (p > 2) p + 2 else 3
            if (isPrime(p)) break
        }
    }
}
