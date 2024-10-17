// version 1.1.2

import java.math.BigInteger

fun perm(n: Int, k: Int): BigInteger {
    require(n > 0 && k >= 0)
    return (n - k + 1 .. n).fold(BigInteger.ONE) { acc, i -> acc * BigInteger.valueOf(i.toLong()) }
}

fun comb(n: Int, k: Int): BigInteger {
    require(n > 0 && k >= 0)
    val fact = (2..k).fold(BigInteger.ONE) { acc, i -> acc * BigInteger.valueOf(i.toLong()) }
    return perm(n, k) / fact
}

fun main(args: Array<String>) {
    println("A sample of permutations from 1 to 12:")
    for (n in 1..12) System.out.printf("%2d P %-2d = %d\n", n, n / 3, perm(n, n / 3))

    println("\nA sample of combinations from 10 to 60:")
    for (n in 10..60 step 10) System.out.printf("%2d C %-2d = %d\n", n, n / 3, comb(n, n / 3))

    println("\nA sample of permutations from 5 to 15000:")
    val na = intArrayOf(5, 50, 500, 1000, 5000, 15000)
    for (n in na) {
        val k = n / 3
        val s = perm(n, k).toString()
        val l = s.length
        val e = if (l <= 40) "" else "... (${l - 40} more digits)"
        System.out.printf("%5d P %-4d = %s%s\n", n, k, s.take(40), e)
    }

    println("\nA sample of combinations from 100 to 1000:")
    for (n in 100..1000 step 100) {
        val k = n / 3
        val s = comb(n, k).toString()
        val l = s.length
        val e = if (l <= 40) "" else "... (${l - 40} more digits)"
        System.out.printf("%4d C %-3d = %s%s\n", n, k, s.take(40), e)
    }
}
