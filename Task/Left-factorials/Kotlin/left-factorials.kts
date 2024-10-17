// version 1.0.6

import java.math.BigInteger

fun leftFactorial(n: Int): BigInteger {
    if (n == 0) return BigInteger.ZERO
    var fact = BigInteger.ONE
    var sum = fact
    for (i in 1 until n) {
        fact *= BigInteger.valueOf(i.toLong())
        sum += fact
    }
    return sum
}

fun main(args: Array<String>) {
    for (i in 0..110)
        if (i <= 10 || (i % 10) == 0)
            println("!${i.toString().padEnd(3)} = ${leftFactorial(i)}")
    println("\nLength of the following left factorials:")
    for (i in 1000..10000 step 1000)
        println("!${i.toString().padEnd(5)} has ${leftFactorial(i).toString().length} digits")
}
