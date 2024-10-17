// version 1.2.10

import java.math.BigInteger

val bigOne   = BigInteger.ONE
val bigTwo   = 2.toBigInteger()
val bigThree = 3.toBigInteger()
val bigTen   = BigInteger.TEN

class PExp(val prime: BigInteger, val exp: Long)

fun moTest(a: BigInteger, n: BigInteger) {
    if (!n.isProbablePrime(20)) {
        println("Not computed. Modulus must be prime for this algorithm.")
        return
    }
    if (a.bitLength() < 100) print("ord($a)") else print("ord([big])")
    if (n.bitLength() < 100) print(" mod $n ") else print(" mod [big] ")
    val mob = moBachShallit58(a, n, factor(n - bigOne))
    println("= $mob")
}

fun moBachShallit58(a: BigInteger, n: BigInteger, pf: List<PExp>): BigInteger {
    val n1 = n - bigOne
    var mo = bigOne
    for (pe in pf) {
        val y = n1 / pe.prime.pow(pe.exp.toInt())
        var o = 0L
        var x = a.modPow(y, n.abs())
        while (x > bigOne) {
            x = x.modPow(pe.prime, n.abs())
            o++
        }
        var o1 = o.toBigInteger()
        o1 = pe.prime.pow(o1.toInt())
        o1 /= mo.gcd(o1)
        mo *= o1
    }
    return mo
}

fun factor(n: BigInteger): List<PExp> {
    val pf = mutableListOf<PExp>()
    var nn = n
    var e = 0L
    while (!nn.testBit(e.toInt())) e++
    if (e > 0L) {
        nn = nn shr e.toInt()
        pf.add(PExp(bigTwo, e))
    }
    var s = bigSqrt(nn)
    var d = bigThree
    while (nn > bigOne) {
        if (d > s) d = nn
        e = 0L
        while (true) {
            val (q, r) = nn.divideAndRemainder(d)
            if (r.bitLength() > 0) break
            nn = q
            e++
        }
        if (e > 0L) {
            pf.add(PExp(d, e))
            s = bigSqrt(nn)
        }
        d += bigTwo
    }
    return pf
}

fun bigSqrt(n: BigInteger): BigInteger {
    var b = n
    while (true) {
        val a = b
        b = (n / a + a) shr 1
        if (b >= a) return a
    }
}

fun main(args: Array<String>) {
    moTest(37.toBigInteger(), 3343.toBigInteger())

    var b = bigTen.pow(100) + bigOne
    moTest(b, 7919.toBigInteger())

    b = bigTen.pow(1000) + bigOne
    moTest(b, BigInteger("15485863"))

    b = bigTen.pow(10000) - bigOne
    moTest(b, BigInteger("22801763489"))

    moTest(BigInteger("1511678068"), BigInteger("7379191741"))
    moTest(BigInteger("3047753288"), BigInteger("2257683301"))
}
