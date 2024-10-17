// version 1.0.6

fun endsWith89(n: Int): Boolean {
    var digit: Int
    var sum = 0
    var nn = n
    while (true) {
        while (nn > 0) {
            digit = nn % 10
            sum += digit * digit
            nn /= 10
        }
        if (sum == 89) return true
        if (sum == 1) return false
        nn = sum
        sum  = 0
    }
}

fun main(args: Array<String>) {
    val sums = IntArray(8 * 81 + 1)
    sums[0] = 1
    sums[1] = 0
    var s: Int
    for (n in 1 .. 8)
        for (i in n * 81 downTo 1)
            for (j in 1 .. 9) {
                s = j * j
                if (s > i) break
                sums[i] += sums[i - s]
            }
    var count89 = 0
    for (i in 1 .. 8 * 81)
        if (endsWith89(i)) count89 += sums[i]
    println("There are $count89 numbers from 1 to 100 million ending with 89")
}
