import java.math.BigInteger

val SMALL_PRIMES = listOf(
    2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97,
    101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199,
    211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293,
    307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397,
    401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499,
    503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599,
    601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691,
    701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797,
    809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887,
    907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997
)

fun isPrime(n: BigInteger): Boolean {
    if (n < 2.toBigInteger()) {
        return false
    }

    for (sp in SMALL_PRIMES) {
        val spb = sp.toBigInteger()
        if (n == spb) {
            return true
        }
        if (n % spb == BigInteger.ZERO) {
            return false
        }
        if (n < spb * spb) {
            //if (n > SMALL_PRIMES.last().toBigInteger()) {
            //    println("Next: $n")
            //}
            return true
        }
    }

    return n.isProbablePrime(10)
}

fun cycle(n: BigInteger): BigInteger {
    var m = n
    var p = 1
    while (m >= BigInteger.TEN) {
        p *= 10
        m /= BigInteger.TEN
    }
    return m + BigInteger.TEN * (n % p.toBigInteger())
}

fun isCircularPrime(p: BigInteger): Boolean {
    if (!isPrime(p)) {
        return false
    }
    var p2 = cycle(p)
    while (p2 != p) {
        if (p2 < p || !isPrime(p2)) {
            return false
        }
        p2 = cycle(p2)
    }
    return true
}

fun testRepUnit(digits: Int) {
    var repUnit = BigInteger.ONE
    var count = digits - 1
    while (count > 0) {
        repUnit = BigInteger.TEN * repUnit + BigInteger.ONE
        count--
    }
    if (isPrime(repUnit)) {
        println("R($digits) is probably prime.")
    } else {
        println("R($digits) is not prime.")
    }
}

fun main() {
    println("First 19 circular primes:")
    var p = 2
    var count = 0
    while (count < 19) {
        if (isCircularPrime(p.toBigInteger())) {
            if (count > 0) {
                print(", ")
            }
            print(p)
            count++
        }
        p++
    }
    println()

    println("Next 4 circular primes:")
    var repUnit = BigInteger.ONE
    var digits = 1
    count = 0
    while (repUnit < p.toBigInteger()) {
        repUnit = BigInteger.TEN * repUnit + BigInteger.ONE
        digits++
    }
    while (count < 4) {
        if (isPrime(repUnit)) {
            print("R($digits) ")
            count++
        }
        repUnit = BigInteger.TEN * repUnit + BigInteger.ONE
        digits++
    }
    println()

    testRepUnit(5003)
    testRepUnit(9887)
    testRepUnit(15073)
    testRepUnit(25031)
    testRepUnit(35317)
    testRepUnit(49081)
}
