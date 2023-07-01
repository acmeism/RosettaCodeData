// version 1.0.6

import java.math.BigInteger

const val LIMIT = 1000000  // expect a run time of about 20 minutes on a typical laptop

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

fun countDigits(bi: BigInteger): Int = bi.toString().length

fun main(args: Array<String>) {
    println("Primorial(0) = 1")
    println("Primorial(1) = 2")
    var count = 1
    var p = 3
    var prod = BigInteger.valueOf(2)
    var target = 10
    while(true) {
        if (isPrime(p)) {
            count++
            prod *= BigInteger.valueOf(p.toLong())
            if (count < 10) {
                println("Primorial($count) = $prod")
                if (count == 9) println()
            }
            else if (count == target) {
                println("Primorial($target) has ${countDigits(prod)} digits")
                if (count == LIMIT) break
                target *= 10
            }
        }
        p += 2
    }
}
