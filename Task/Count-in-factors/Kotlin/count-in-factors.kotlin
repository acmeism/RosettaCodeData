// version 1.1.2

fun isPrime(n: Int) : Boolean {
    if (n < 2) return false
    if (n % 2 == 0) return n == 2
    if (n % 3 == 0) return n == 3
    var d = 5
    while (d * d <= n) {
        if (n % d == 0) return false
        d += 2
        if (n % d == 0) return false
        d += 4
    }
    return true
}

fun getPrimeFactors(n: Int): List<Int> {
    val factors = mutableListOf<Int>()
    if (n < 1) return factors
    if (n == 1 || isPrime(n)) {
        factors.add(n)
        return factors
    }
    var factor = 2
    var nn = n
    while (true) {
        if (nn % factor == 0) {
            factors.add(factor)
            nn /= factor
            if (nn == 1) return factors
            if (isPrime(nn)) factor = nn
        }
        else if (factor >= 3) factor += 2
        else factor = 3
    }
}

fun main(args: Array<String>) {
    val list = (MutableList(22) { it + 1 } + 2144) + 6358
    for (i in list)
        println("${"%4d".format(i)} = ${getPrimeFactors(i).joinToString(" * ")}")
}
