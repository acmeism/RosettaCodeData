// version 1.0.6

import java.math.BigInteger

const val MAX = 19

val bigTwo  = BigInteger.valueOf(2L)
val bigFour = bigTwo * bigTwo

fun isPrime(n: Int): Boolean {
    if (n < 2) return false
    if (n % 2 == 0) return n == 2
    if (n % 3 == 0) return n == 3
    var d : Int = 5
    while (d * d <= n) {
        if (n % d == 0) return false
        d += 2
        if (n % d == 0) return false
        d += 4
    }
    return true
}

fun main(args: Array<String>) {
    var count = 0
    var p = 3   // first odd prime
    var s: BigInteger
    var m: BigInteger
    while (true) {
        m = bigTwo.shiftLeft(p - 1) - BigInteger.ONE
        s = bigFour
        for (i in 1 .. p - 2) s = (s * s - bigTwo) % m
        if (s == BigInteger.ZERO) {
            count +=1
            print("M$p ")
            if (count == MAX) {
                println()
                break
            }
        }
        // obtain next odd prime
        while(true) {
            p += 2
            if (isPrime(p)) break
        }
    }
}
