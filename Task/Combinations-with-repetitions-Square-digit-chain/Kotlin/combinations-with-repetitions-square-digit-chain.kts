// version 1.1.51

fun endsWithOne(n: Int): Boolean {
    var digit: Int
    var sum = 0
    var nn = n
    while (true) {
        while (nn > 0) {
            digit = nn % 10
            sum += digit * digit
            nn /= 10
        }
        if (sum == 1) return true
        if (sum == 89) return false
        nn = sum
        sum  = 0
    }
}

fun main(args: Array<String>) {
    val ks = intArrayOf(7, 8, 11, 14, 17)
    for (k in ks) {
        val sums = LongArray(k * 81 + 1)
        sums[0] = 1
        sums[1] = 0
        var s: Int
        for (n in 1 .. k) {
            for (i in n * 81 downTo 1) {
                for (j in 1 .. 9) {
                    s = j * j
                    if (s > i) break
                    sums[i] += sums[i - s]
                }
            }
        }
        var count1 = 0L
        for (i in 1 .. k * 81) if (endsWithOne(i)) count1 += sums[i]
        val limit = Math.pow(10.0, k.toDouble()).toLong() - 1
        println("For k = $k in the range 1 to $limit")
        println("$count1 numbers produce 1 and ${limit - count1} numbers produce 89\n")
    }
}
