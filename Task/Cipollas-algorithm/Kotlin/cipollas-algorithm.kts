// version 1.2.0

import java.math.BigInteger

class Point(val x: BigInteger, val y: BigInteger)

val bigZero = BigInteger.ZERO
val bigOne  = BigInteger.ONE
val bigTwo  = BigInteger.valueOf(2L)
val bigBig  = BigInteger.TEN.pow(50) + BigInteger.valueOf(151L)

fun c(ns: String, ps: String): Triple<BigInteger, BigInteger, Boolean> {
    val n = BigInteger(ns)
    val p = if (!ps.isEmpty()) BigInteger(ps) else bigBig

    // Legendre symbol, returns 1, 0 or p - 1
    fun ls(a: BigInteger) = a.modPow((p - bigOne) / bigTwo, p)

    // Step 0, validate arguments
    if (ls(n) != bigOne) return Triple(bigZero, bigZero, false)

    // Step 1, find a, omega2
    var a = bigZero
    var omega2: BigInteger
    while (true) {
        omega2 = (a * a + p - n) % p
        if (ls(omega2) == p - bigOne) break
        a++
    }

    // multiplication in Fp2
    fun mul(aa: Point, bb: Point) =
        Point(
            (aa.x * bb.x + aa.y * bb.y * omega2) % p,
            (aa.x * bb.y + bb.x * aa.y) % p
        )

    // Step 2, compute power
    var r = Point(bigOne, bigZero)
    var s = Point(a, bigOne)
    var nn = ((p + bigOne) shr 1) % p
    while (nn > bigZero) {
        if ((nn and bigOne) == bigOne) r = mul(r, s)
        s = mul(s, s)
        nn = nn shr 1
    }

    // Step 3, check x in Fp
    if (r.y != bigZero) return Triple(bigZero, bigZero, false)

    // Step 5, check x * x = n
    if (r.x * r.x % p != n) return Triple(bigZero, bigZero, false)

    // Step 4, solutions
    return Triple(r.x, p - r.x, true)
}

fun main(args: Array<String>) {
    println(c("10", "13"))
    println(c("56", "101"))
    println(c("8218", "10007"))
    println(c("8219", "10007"))
    println(c("331575", "1000003"))
    println(c("665165880", "1000000007"))
    println(c("881398088036", "1000000000039"))
    println(c("34035243914635549601583369544560650254325084643201", ""))
}
