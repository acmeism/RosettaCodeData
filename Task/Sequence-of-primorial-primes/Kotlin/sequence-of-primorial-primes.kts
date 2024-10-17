// version 1.0.6

import java.math.BigInteger

const val LIMIT = 20  // expect a run time of about 2 minutes on a typical laptop

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
    println("The first $LIMIT primorial indices in the sequence are:")
    print("1 ")
    var primorial = 1
    var count = 1
    var p = 3
    var prod = BigInteger.valueOf(2L)
    while(true) {
        if (isPrime(p)) {
            prod *= BigInteger.valueOf(p.toLong())
            primorial++
            if ((prod + BigInteger.ONE).isProbablePrime(1) || (prod - BigInteger.ONE).isProbablePrime(1)) {
                print("$primorial ")
                count++
                if (count == LIMIT) {
                    println()
                    break
                }
            }
        }
        p += 2
    }
}
