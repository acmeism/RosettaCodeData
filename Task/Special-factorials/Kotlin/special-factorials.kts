import java.math.BigInteger
import java.util.function.Function

/* n! = 1 * 2 * 3 * ... * n */
fun factorial(n: Int): BigInteger {
    val bn = BigInteger.valueOf(n.toLong())
    var result = BigInteger.ONE
    var i = BigInteger.TWO
    while (i <= bn) {
        result *= i++
    }
    return result
}

/* if(n!) = n */
fun inverseFactorial(f: BigInteger): Int {
    if (f == BigInteger.ONE) {
        return 0
    }

    var p = BigInteger.ONE
    var i = BigInteger.ONE

    while (p < f) {
        p *= i++
    }

    if (p == f) {
        return i.toInt() - 1
    }
    return -1
}

/* sf(n) = 1! * 2! * 3! * ... . n! */
fun superFactorial(n: Int): BigInteger {
    var result = BigInteger.ONE
    for (i in 1..n) {
        result *= factorial(i)
    }
    return result
}

/* H(n) = 1^1 * 2^2 * 3^3 * ... * n^n */
fun hyperFactorial(n: Int): BigInteger {
    var result = BigInteger.ONE
    for (i in 1..n) {
        val bi = BigInteger.valueOf(i.toLong())
        result *= bi.pow(i)
    }
    return result
}

/* af(n) = -1^(n-1)*1! + -1^(n-2)*2! + ... + -1^(0)*n! */
fun alternatingFactorial(n: Int): BigInteger {
    var result = BigInteger.ZERO
    for (i in 1..n) {
        if ((n - i) % 2 == 0) {
            result += factorial(i)
        } else {
            result -= factorial(i)
        }
    }
    return result
}

/* n$ = n ^ (n - 1) ^ ... ^ (2) ^ 1 */
fun exponentialFactorial(n: Int): BigInteger {
    var result = BigInteger.ZERO
    for (i in 1..n) {
        result = BigInteger.valueOf(i.toLong()).pow(result.toInt())
    }
    return result
}

fun testFactorial(count: Int, f: Function<Int, BigInteger>, name: String) {
    println("First $count $name:")
    for (i in 0 until count) {
        print("${f.apply(i)} ")
    }
    println()
}

fun testInverse(f: Long) {
    val n = inverseFactorial(BigInteger.valueOf(f))
    if (n < 0) {
        println("rf($f) = No Solution")
    } else {
        println("rf($f) = $n")
    }
}

fun main() {
    testFactorial(10, ::superFactorial, "super factorials")
    println()

    testFactorial(10, ::hyperFactorial, "hyper factorials")
    println()

    testFactorial(10, ::alternatingFactorial, "alternating factorials")
    println()

    testFactorial(5, ::exponentialFactorial, "exponential factorials")
    println()

    testInverse(1)
    testInverse(2)
    testInverse(6)
    testInverse(24)
    testInverse(120)
    testInverse(720)
    testInverse(5040)
    testInverse(40320)
    testInverse(362880)
    testInverse(3628800)
    testInverse(119)
}
