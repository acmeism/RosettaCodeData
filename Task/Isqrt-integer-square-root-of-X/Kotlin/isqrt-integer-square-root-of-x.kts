import java.math.BigInteger

fun isqrt(x: BigInteger): BigInteger {
    if (x < BigInteger.ZERO) {
        throw IllegalArgumentException("Argument cannot be negative")
    }
    var q = BigInteger.ONE
    while (q <= x) {
        q = q.shiftLeft(2)
    }
    var z = x
    var r = BigInteger.ZERO
    while (q > BigInteger.ONE) {
        q = q.shiftRight(2)
        var t = z
        t -= r
        t -= q
        r = r.shiftRight(1)
        if (t >= BigInteger.ZERO) {
            z = t
            r += q
        }
    }
    return r
}

fun main() {
    println("The integer square root of integers from 0 to 65 are:")
    for (i in 0..65) {
        print("${isqrt(BigInteger.valueOf(i.toLong()))} ")
    }
    println()

    println("The integer square roots of powers of 7 from 7^1 up to 7^73 are:")
    println("power                                    7 ^ power                                                 integer square root")
    println("----- --------------------------------------------------------------------------------- -----------------------------------------")
    var pow7 = BigInteger.valueOf(7)
    val bi49 = BigInteger.valueOf(49)
    for (i in (1..73).step(2)) {
        println("%2d %,84d %,41d".format(i, pow7, isqrt(pow7)))
        pow7 *= bi49
    }
}
