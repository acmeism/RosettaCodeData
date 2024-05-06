// Version 1.3.21

const val MAX = 15

fun countDivisors(n: Int): Int {
    var count = 0
    var i = 1
    while (i * i <= n) {
        if (n % i == 0) {
            count += if (i == n / i) 1 else 2
        }
        i++
    }
    return count
}

fun main() {
    println("The first $MAX terms of the sequence are:")
    var i = 1
    var next = 1
    while (next <= MAX) {
        if (next == countDivisors(i)) {
            print("$i ")
            next++
        }
        i++
    }
    println()
}
