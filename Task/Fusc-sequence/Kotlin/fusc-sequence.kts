// Version 1.3.21

fun fusc(n: Int): IntArray {
    if (n <= 0) return intArrayOf()
    if (n == 1) return intArrayOf(0)
    val res = IntArray(n)
    res[1] = 1
    for (i in 2 until n) {
        if (i % 2 == 0) {
            res[i] = res[i / 2]
        } else {
            res[i] = res[(i - 1) / 2] + res[(i + 1) / 2]
        }
    }
    return res
}

fun fuscMaxLen(n: Int): List<Pair<Int, Int>> {
    var maxLen = -1
    var maxFusc = -1
    val f = fusc(n)
    val res = mutableListOf<Pair<Int, Int>>()
    for (i in 0 until n) {
        if (f[i] <= maxFusc) continue // avoid string conversion
        maxFusc = f[i]
        val len = f[i].toString().length
        if (len > maxLen) {
            res.add(Pair(i, f[i]))
            maxLen = len
        }
    }
    return res
}

fun main() {
    println("The first 61 fusc numbers are:")
    println(fusc(61).asList())
    println("\nThe fusc numbers whose length > any previous fusc number length are:")
    val res = fuscMaxLen(20_000_000)  // examine first 20 million numbers say
    for (r in res) {
        System.out.printf("%,7d (index %,10d)\n", r.second, r.first)
    }
}
