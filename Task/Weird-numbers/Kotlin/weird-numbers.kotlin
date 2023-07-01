// Version 1.3.21

fun divisors(n: Int): List<Int> {
    val divs = mutableListOf(1)
    val divs2 = mutableListOf<Int>()
    var i = 2
    while (i * i <= n) {
        if (n % i == 0) {
            val j = n / i
            divs.add(i)
            if (i != j) divs2.add(j)
        }
        i++
    }
    divs2.addAll(divs.asReversed())
    return divs2
}

fun abundant(n: Int, divs: List<Int>) = divs.sum() > n

fun semiperfect(n: Int, divs: List<Int>): Boolean {
    if (divs.size > 0) {
        val h = divs[0]
        val t = divs.subList(1, divs.size)
        if (n < h) {
            return semiperfect(n, t)
        } else {
            return n == h || semiperfect(n-h, t) || semiperfect(n, t)
        }
    } else {
        return false
    }
}

fun sieve(limit: Int): BooleanArray {
    // false denotes abundant and not semi-perfect.
    // Only interested in even numbers >= 2
    val w = BooleanArray(limit)
    for (i in 2 until limit step 2) {
        if (w[i]) continue
        val divs = divisors(i)
        if (!abundant(i, divs)) {
            w[i] = true
        } else if (semiperfect(i, divs)) {
            for (j in i until limit step i) w[j] = true
        }
    }
    return w
}

fun main() {
    val w = sieve(17000)
    var count = 0
    val max = 25
    println("The first 25 weird numbers are:")
    var n = 2
    while (count < max) {
        if (!w[n]) {
            print("$n ")
            count++
        }
        n += 2
    }
    println()
}
