// version 1.1.2

import java.math.BigInteger

val ZERO  = BigInteger.ZERO
val ONE   = BigInteger.ONE
val TWO   = BigInteger.valueOf(2L)
val THREE = BigInteger.valueOf(3L)
val FOUR  = BigInteger.valueOf(4L)
val SEVEN = BigInteger.valueOf(7L)
val TEN   = BigInteger.TEN

fun calcPi() {
    var nn: BigInteger
    var nr: BigInteger
    var q = ONE
    var r = ZERO
    var t = ONE
    var k = ONE
    var n = THREE
    var l = THREE
    var first = true
    while (true) {
        if (FOUR * q + r - t < n * t) {
            print(n)
            if (first) { print ("."); first = false }
            nr = TEN * (r - n * t)
            n = TEN * (THREE * q + r) / t - TEN * n
            q *= TEN
            r = nr
        }
        else {
            nr = (TWO * q + r) * l
            nn = (q * SEVEN * k + TWO + r * l) / (t * l)
            q *= k
            t *= l
            l += TWO
            k += ONE
            n = nn
            r = nr
        }
    }
}

fun main(args: Array<String>) = calcPi()
