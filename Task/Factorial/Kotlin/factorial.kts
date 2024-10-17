fun facti(n: Int) = when {
    n < 0 -> throw IllegalArgumentException("negative numbers not allowed")
    else  -> {
        var ans = 1L
        for (i in 2..n) ans *= i
        ans
    }
}

fun factr(n: Int): Long = when {
    n < 0 -> throw IllegalArgumentException("negative numbers not allowed")
    n < 2 -> 1L
    else  -> n * factr(n - 1)
}

fun main(args: Array<String>) {
    val n = 20
    println("$n! = " + facti(n))
    println("$n! = " + factr(n))
}
