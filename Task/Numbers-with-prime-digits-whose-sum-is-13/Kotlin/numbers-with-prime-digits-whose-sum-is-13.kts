fun primeDigitsSum13(n: Int): Boolean {
    var nn = n
    var sum = 0
    while (nn > 0) {
        val r = nn % 10
        if (r != 2 && r != 3 && r != 5 && r != 7) {
            return false
        }
        nn /= 10
        sum += r
    }
    return sum == 13
}

fun main() {
    // using 2 for all digits, 6 digits is the max prior to over-shooting 13
    var c = 0
    for (i in 1 until 1000000) {
        if (primeDigitsSum13(i)) {
            print("%6d ".format(i))
            if (c++ == 10) {
                c = 0
                println()
            }
        }
    }
    println()
}
