// version 1.1.2

fun areSame(a: IntArray, b: IntArray): Boolean {
    for (i in 0 until a.size) if (a[i] != b[i]) return false
    return true
}

fun perfectShuffle(a: IntArray): IntArray {
    var b = IntArray(a.size)
    val hSize = a.size / 2
    for (i in 0 until hSize) b[i * 2] = a[i]
    var j = 1
    for (i in hSize until a.size) {
        b[j] = a[i]
        j += 2
    }
    return b
}

fun countShuffles(a: IntArray): Int {
    require(a.size >= 2 && a.size % 2 == 0)
    var b = a
    var count = 0
    while (true) {
        val c = perfectShuffle(b)
        count++
        if (areSame(a, c)) return count
        b = c
    }
}

fun main(args: Array<String>) {
    println("Deck size  Num shuffles")
    println("---------  ------------")
    val sizes = intArrayOf(8, 24, 52, 100, 1020, 1024, 10000)
    for (size in sizes) {
        val a = IntArray(size) { it }
        val count = countShuffles(a)
        println("${"%-9d".format(size)}     $count")
    }
}
