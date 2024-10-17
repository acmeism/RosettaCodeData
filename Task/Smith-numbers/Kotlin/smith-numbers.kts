// version 1.0.6

fun getPrimeFactors(n: Int): MutableList<Int> {
    val factors = mutableListOf<Int>()
    if (n < 2) return factors
    var factor = 2
    var nn = n
    while (true) {
        if (nn % factor == 0) {
            factors.add(factor)
            nn /= factor
            if (nn == 1) return factors
        }
        else if (factor >= 3) factor += 2
        else factor = 3
    }
}

fun sumDigits(n: Int): Int = when {
        n < 10 -> n
        else   -> {
            var sum = 0
            var nn = n
            while (nn > 0) {
                sum += (nn % 10)
                nn /= 10
            }
            sum
        }
    }

fun isSmith(n: Int): Boolean {
    if (n < 2) return false
    val factors = getPrimeFactors(n)
    if (factors.size == 1) return false
    val primeSum = factors.sumBy { sumDigits(it) }
    return sumDigits(n) == primeSum
}

fun main(args: Array<String>) {
    println("The Smith numbers below 10000 are:\n")
    var count = 0
    for (i in 2 until 10000) {
        if (isSmith(i)) {
            print("%5d".format(i))
            count++
        }
    }
    println("\n\n$count numbers found")
}
