// Version 1.3.21

const val MAX = 120

fun isPrime(n: Int) : Boolean {
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

fun countPrimeFactors(n: Int) =
    when {
        n == 1  -> 0
        isPrime(n) -> 1
        else -> {
            var nn = n
            var count = 0
            var f = 2
            while (true) {
                if (nn % f == 0) {
                    count++
                    nn /= f
                    if (nn == 1) break
                    if (isPrime(nn)) f = nn
                } else if (f >= 3) {
                    f += 2
                } else {
                    f = 3
                }
            }
            count
        }
    }

fun main() {
    println("The attractive numbers up to and including $MAX are:")
    var count = 0
    for (i in 1..MAX) {
        val n = countPrimeFactors(i)
        if (isPrime(n)) {
            System.out.printf("%4d", i)
            if (++count % 20 == 0) println()
        }
    }
    println()
}
