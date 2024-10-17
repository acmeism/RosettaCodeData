//  version 1.0.5-2

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

fun getPopulationCount(n: Int): Int {
    if (n <= 0) return 0
    var nn = n
    var sum = 0
    while (nn > 0) {
        sum += nn % 2
        nn /= 2
    }
    return sum
}

fun isPernicious(n: Int): Boolean = isPrime(getPopulationCount(n))

fun main(args: Array<String>) {
    var n = 1
    var count = 0
    println("The first 25 pernicious numbers are:\n")
    do {
        if (isPernicious(n)) {
           print("$n ")
           count++
        }
        n++
    }
    while (count < 25)
    println("\n")
    println("The pernicious numbers between 888,888,877 and 888,888,888 inclusive are:\n")
    for (i in 888888877..888888888) {
        if (isPernicious(i)) print("$i ")
    }
}
