import java.math.BigInteger
import java.math.BigInteger.ONE

enum class Difference(private val displayText: String) {
    MINUS_ONE("- 1"), PLUS_ONE("+ 1");

    override fun toString(): String {
        return displayText
    }
}

fun main() {
    var currentFactorial = ONE
    var highestFactor = 1L
    var found = 0

    while(found < 30) {
        if ((currentFactorial - ONE).isProbablePrime(25)) {
            printlnFactorialPrime(currentFactorial - ONE, highestFactor, Difference.MINUS_ONE)
            found++
        }
        if ((currentFactorial + ONE).isProbablePrime(25)) {
            printlnFactorialPrime(currentFactorial + ONE, highestFactor, Difference.PLUS_ONE)
            found++
        }

        highestFactor++
        currentFactorial *= BigInteger.valueOf(highestFactor)
    }
}

fun printlnFactorialPrime(factorialPrime: BigInteger, base: Long, difference: Difference) =
    println("${base}! $difference = ${factorialPrime.shortenIfNecessary()}")

fun BigInteger.shortenIfNecessary(): String {
    val digits = toString()
    val length = digits.length
    return if (length <= 40) {
        digits
    } else {
        "${digits.take(20)}...${digits.takeLast(20)} ($length digits)"
    }
}
