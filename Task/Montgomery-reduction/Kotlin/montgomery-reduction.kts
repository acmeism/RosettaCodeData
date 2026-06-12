// version 1.1.3

import java.math.BigInteger

val bigZero = BigInteger.ZERO
val bigOne  = BigInteger.ONE
val bigTwo  = BigInteger.valueOf(2L)

class Montgomery(val m: BigInteger) {
    val n:   Int
    val rrm: BigInteger

    init {
        require(m > bigZero && m.testBit(0)) // must be positive and odd
        n = m.bitLength()
        rrm = bigOne.shiftLeft(n * 2).mod(m)
    }

    fun reduce(t: BigInteger): BigInteger {
        var a = t
        for (i in 0 until n) {
            if (a.testBit(0)) a += m
            a = a.shiftRight(1)
        }
        if (a >= m) a -= m
        return a
    }

    companion object {
        const val BASE = 2
    }
}

fun main(args: Array<String>) {
    val m  = BigInteger("750791094644726559640638407699")
    val x1 = BigInteger("540019781128412936473322405310")
    val x2 = BigInteger("515692107665463680305819378593")

    val mont = Montgomery(m)
    val t1 = x1 * mont.rrm
    val t2 = x2 * mont.rrm

    val r1 = mont.reduce(t1)
    val r2 = mont.reduce(t2)
    val r  = bigOne.shiftLeft(mont.n)

    println("b :  ${Montgomery.BASE}")
    println("n :  ${mont.n}")
    println("r :  $r")
    println("m :  ${mont.m}")
    println("t1:  $t1")
    println("t2:  $t2")
    println("r1:  $r1")
    println("r2:  $r2")
    println()
    println("Original x1       : $x1")
    println("Recovered from r1 : ${mont.reduce(r1)}")
    println("Original x2       : $x2")
    println("Recovered from r2 : ${mont.reduce(r2)}")

    println("\nMontgomery computation of x1 ^ x2 mod m :")
    var prod = mont.reduce(mont.rrm)
    var base = mont.reduce(x1 * mont.rrm)
    var exp  = x2
    while (exp.bitLength() > 0) {
        if (exp.testBit(0)) prod = mont.reduce(prod * base)
        exp = exp.shiftRight(1)
        base = mont.reduce(base * base)
    }
    println(mont.reduce(prod))
    println("\nLibrary-based computation of x1 ^ x2 mod m :")
    println(x1.modPow(x2, m))
}
