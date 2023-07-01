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
    var seq = IntArray(MAX)
    println("The first $MAX terms of the sequence are:")
    var i = 1
    var n = 0
    while (n < MAX) {
        var k = countDivisors(i)
        if (k <= MAX && seq[k - 1] == 0) {
            seq[k - 1] = i
            n++
        }
        i++
    }
    println(seq.asList())
}
