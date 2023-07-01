// Version 1.3.21

fun totient(n: Int): Int {
    var tot = n
    var nn = n
    var i = 2
    while (i * i <= nn) {
        if (nn % i == 0) {
            while (nn % i == 0) nn /= i
            tot -= tot / i
        }
        if (i == 2) i = 1
        i += 2
    }
    if (nn > 1) tot -= tot / nn
    return tot
}

fun main() {
    val perfect = mutableListOf<Int>()
    var n = 1
    while (perfect.size < 20) {
        var tot = n
        var sum = 0
        while (tot != 1) {
            tot = totient(tot)
            sum += tot
        }
        if (sum == n) perfect.add(n)
        n += 2
    }
    println("The first 20 perfect totient numbers are:")
    println(perfect)
}
