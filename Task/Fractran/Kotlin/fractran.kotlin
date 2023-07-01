// version 1.1.3

import java.math.BigInteger

class Fraction(val num: BigInteger, val denom: BigInteger) {
    operator fun times(n: BigInteger) = Fraction (n * num, denom)

    fun isIntegral() = num % denom == BigInteger.ZERO
}

fun String.toFraction(): Fraction {
    val split = this.split('/')
    return Fraction(BigInteger(split[0]), BigInteger(split[1]))
}

val BigInteger.isPowerOfTwo get() = this.and(this - BigInteger.ONE) == BigInteger.ZERO

val log2 = Math.log(2.0)

fun fractran(program: String, n: Int, limit: Int, primesOnly: Boolean): List<Int> {
    val fractions = program.split(' ').map { it.toFraction() }
    val results = mutableListOf<Int>()
    if (!primesOnly) results.add(n)
    var nn = BigInteger.valueOf(n.toLong())
    while (results.size < limit) {
        val frac = fractions.find { (it * nn).isIntegral() } ?: break
        nn = nn * frac.num / frac.denom
        if (!primesOnly) {
           results.add(nn.toInt())
        }
        else if (primesOnly && nn.isPowerOfTwo) {
           val prime = (Math.log(nn.toDouble()) / log2).toInt()
           results.add(prime)
        }
    }
    return results
}

fun main(args: Array<String>) {
    val program = "17/91 78/85 19/51 23/38 29/33 77/29 95/23 77/19 1/17 11/13 13/11 15/14 15/2 55/1"
    println("First twenty numbers:")
    println(fractran(program, 2, 20, false))
    println("\nFirst twenty primes:")
    println(fractran(program, 2, 20, true))
}
