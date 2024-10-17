// version 2.0

fun binomial(n: Int, k: Int) = when {
    n < 0 || k < 0 -> throw IllegalArgumentException("negative numbers not allowed")
    n == k         -> 1L
    else           -> {
        val kReduced = min(k, n - k)    // minimize number of steps
        var result = 1L
        var numerator = n
        var denominator = 1
        while (denominator <= kReduced)
            result = result * numerator-- / denominator++
        result
    }
}

fun main(args: Array<String>) {
    for (n in 0..14) {
        for (k in 0..n)
            print("%4d ".format(binomial(n, k)))
        println()
    }
}
