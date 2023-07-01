// Version 1.3.10

fun countDivisors(n: Int): Int {
    if (n < 2) return 1;
    var count = 2 // 1 and n
    for (i in 2..n / 2) {
        if (n % i == 0) count++
    }
    return count;
}

fun main(args: Array<String>) {
    println("The first 20 anti-primes are:")
    var maxDiv = 0
    var count = 0
    var n = 1
    while (count < 20) {
        val d = countDivisors(n)
        if (d > maxDiv) {
            print("$n ")
            maxDiv = d
            count++
        }
        n++
    }
    println()
}
