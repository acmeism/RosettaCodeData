// version 1.0.6

import java.math.BigInteger

val bigTwo   = BigInteger.valueOf(2L)
val bigThree = BigInteger.valueOf(3L)

fun getPrimeFactors(n: BigInteger): MutableList<BigInteger> {
    val factors = mutableListOf<BigInteger>()
    if (n < bigTwo) return factors
    if (n.isProbablePrime(20)) {
        factors.add(n)
        return factors
    }
    var factor = bigTwo
    var nn = n
    while (true) {
        if (nn % factor == BigInteger.ZERO) {
            factors.add(factor)
            nn /= factor
            if (nn == BigInteger.ONE) return factors
            if (nn.isProbablePrime(20)) factor = nn
        }
        else if (factor >= bigThree) factor += bigTwo
        else factor = bigThree
    }
}

fun main(args: Array<String>) {
    val primes = intArrayOf(2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97)
    for (prime in primes) {
        val bigPow2 = bigTwo.pow(prime) - BigInteger.ONE
        println("2^${"%2d".format(prime)} - 1 = ${bigPow2.toString().padEnd(30)} => ${getPrimeFactors(bigPow2)}")
    }
}
