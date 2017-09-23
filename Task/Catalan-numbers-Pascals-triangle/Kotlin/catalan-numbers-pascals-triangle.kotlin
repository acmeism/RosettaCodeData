// version 1.1.2

import java.math.BigInteger

val ONE = BigInteger.ONE

fun pascal(n: Int, k: Int): BigInteger {
    if (n == 0 || k == 0) return ONE
    val num = (k + 1..n).fold(ONE) { acc, i -> acc * BigInteger.valueOf(i.toLong()) }
    val den = (2..n - k).fold(ONE) { acc, i -> acc * BigInteger.valueOf(i.toLong()) }
    return num / den
}

fun catalanFromPascal(n: Int) {
    for (i in 1 until n step 2) {
        val mi = i / 2 + 1
        val catalan = pascal(i, mi) - pascal(i, mi - 2)
        println("${"%2d".format(mi)} : $catalan")
    }
}

fun main(args: Array<String>) {
    val n = 15
    catalanFromPascal(n * 2)
}
