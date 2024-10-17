// version 1.0.6

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
    // print all primes below 2000 say
    var count = 1
    print("    2")
    for (i in 3..1999 step 2)
        if (isPrime(i)) {
            count++
            print("%5d".format(i))
            if (count % 15 == 0) println()
        }
}
