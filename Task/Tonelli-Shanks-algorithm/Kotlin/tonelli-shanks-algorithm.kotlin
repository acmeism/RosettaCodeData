// version 1.1.3

import java.math.BigInteger

data class Solution(val root1: BigInteger, val root2: BigInteger, val exists: Boolean)

val bigZero = BigInteger.ZERO
val bigOne  = BigInteger.ONE
val bigTwo  = BigInteger.valueOf(2L)
val bigFour = BigInteger.valueOf(4L)
val bigTen  = BigInteger.TEN

fun ts(n: Long, p: Long) = ts(BigInteger.valueOf(n), BigInteger.valueOf(p))

fun ts(n: BigInteger, p: BigInteger): Solution {

    fun powModP(a: BigInteger, e: BigInteger) = a.modPow(e, p)

    fun ls(a: BigInteger) = powModP(a, (p - bigOne) / bigTwo)

    if (ls(n) != bigOne) return Solution(bigZero, bigZero, false)
    var q = p - bigOne
    var ss = bigZero
    while (q.and(bigOne) == bigZero) {
        ss = ss + bigOne
        q = q.shiftRight(1)
    }

    if (ss == bigOne) {
        val r1 = powModP(n, (p + bigOne) / bigFour)
        return Solution(r1, p - r1, true)
    }

    var z = bigTwo
    while (ls(z) != p - bigOne) z = z + bigOne
    var c = powModP(z, q)
    var r = powModP(n, (q + bigOne) / bigTwo)
    var t = powModP(n, q)
    var m = ss

    while (true) {
        if (t == bigOne) return Solution(r, p - r, true)
        var i = bigZero
        var zz = t
        while (zz != bigOne && i < m - bigOne) {
            zz  = zz * zz % p
            i = i + bigOne
        }
        var b = c
        var e = m - i - bigOne
        while (e > bigZero) {
            b = b * b % p
            e = e - bigOne
        }
        r = r * b % p
        c = b * b % p
        t = t * c % p
        m = i
    }
}

fun main(args: Array<String>) {
    val pairs = listOf<Pair<Long, Long>>(
        10L to 13L,
        56L to 101L,
        1030L to 10009L,
        1032L to 10009L,
        44402L to 100049L,
        665820697L to 1000000009L,
        881398088036L to 1000000000039L
    )

    for (pair in pairs) {
        val (n, p) = pair
        val (root1, root2, exists) = ts(n, p)
        println("n = $n")
        println("p = $p")
        if (exists) {
            println("root1 = $root1")
            println("root2 = $root2")
        }
        else println("No solution exists")
        println()
    }

    val bn = BigInteger("41660815127637347468140745042827704103445750172002")
    val bp = bigTen.pow(50) + BigInteger.valueOf(577L)
    val (broot1, broot2, bexists) = ts(bn, bp)
    println("n = $bn")
    println("p = $bp")
    if (bexists) {
        println("root1 = $broot1")
        println("root2 = $broot2")
    }
    else println("No solution exists")
}
