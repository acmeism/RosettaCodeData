// version 1.1.2

import java.math.BigInteger

val big2  = BigInteger.valueOf(2)
val big3  = BigInteger.valueOf(3)
val big5  = BigInteger.valueOf(5)
val big15 = big3 * big5

fun sum35(n: Int) = (3 until n).filter { it % 3 == 0 || it % 5 == 0}.sum()

fun sum35(n: BigInteger): BigInteger {
    val nn    = n - BigInteger.ONE
    val num3  = nn / big3
    val end3  = num3 * big3
    val sum3  = (big3 + end3) * num3 / big2
    val num5  = nn / big5
    val end5  = num5 * big5
    val sum5  = (big5 + end5) * num5 / big2
    val num15 = nn / big15
    val end15 = num15 * big15
    val sum15 = (big15 + end15) * num15 / big2
    return sum3 + sum5 - sum15
}

fun main(args: Array<String>) {
    println("The sum of multiples of 3 or 5 below 1000 is ${sum35(1000)}")
    val big100k = BigInteger.valueOf(100_000L)
    val e20 = big100k * big100k * big100k * big100k
    println("The sum of multiples of 3 or 5 below 1e20 is ${sum35(e20)}")
}
