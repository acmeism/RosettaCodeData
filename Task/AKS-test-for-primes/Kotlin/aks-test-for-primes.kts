// version 1.1

fun binomial(n: Int, k: Int): Long = when {
    n < 0 || k < 0 -> throw IllegalArgumentException("negative numbers not allowed")
    k == 0         -> 1L
    k == n         -> 1L
    else           -> {
        var prod = 1L
        var div  = 1L
        for (i in 1..k) {
            prod *= (n + 1 - i)
            div  *= i
            if (prod % div == 0L) {
                prod /= div
                div = 1L
            }
        }
        prod
    }
}

fun isPrime(n: Int): Boolean {
    if (n < 2) return false
    return (1 until n).none { binomial(n, it) % n.toLong() != 0L }
}

fun main(args: Array<String>) {
    var coeff: Long
    var sign: Int
    var op: String
    for (n in 0..9) {
        print("(x - 1)^$n = ")
        sign = 1
        for (k in n downTo 0) {
            coeff = binomial(n, k)
            op = if (sign == 1) " + " else " - "
            when (k) {
                n    -> print("x^$n")
                0    -> println("${op}1")
                else -> print("$op${coeff}x^$k")
            }
            if (n == 0) println()
            sign *= -1
        }
    }
    // generate primes under 62
    var p = 2
    val primes = mutableListOf<Int>()
    do {
        if (isPrime(p)) primes.add(p)
        if (p != 2) p += 2 else p = 3
    }
    while (p < 62)
    println("\nThe prime numbers under 62 are:")
    println(primes)
}
