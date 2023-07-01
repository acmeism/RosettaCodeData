// version 1.0.6

fun countCoins(c: IntArray, m: Int, n: Int): Long {
    val table = LongArray(n + 1)
    table[0] = 1
    for (i in 0 until m)
        for (j in c[i]..n) table[j] += table[j - c[i]]
    return table[n]
}

fun main(args: Array<String>) {
    val c = intArrayOf(1, 5, 10, 25, 50, 100)
    println(countCoins(c, 4, 100))
    println(countCoins(c, 6, 1000 * 100))
}
