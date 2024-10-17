private fun commatize(n: Long): String {
    val sb = StringBuilder(n.toString())
    val le = sb.length
    var i = le - 3
    while (i >= 1) {
        sb.insert(i, ',')
        i -= 3
    }
    return sb.toString()
}

fun main() {
    val starts = listOf(1e2.toLong(), 1e6.toLong(), 1e7.toLong(), 1e9.toLong(), 7123.toLong())
    val counts = listOf(30, 15, 15, 10, 25)
    for (i in starts.indices) {
        var count = 0
        var j = starts[i]
        var pow: Long = 100
        while (j >= pow * 10) {
            pow *= 10
        }
        System.out.printf(
            "First %d gapful numbers starting at %s:\n",
            counts[i],
            commatize(starts[i])
        )
        while (count < counts[i]) {
            val fl = j / pow * 10 + j % 10
            if (j % fl == 0L) {
                System.out.printf("%d ", j)
                count++
            }
            j++
            if (j >= 10 * pow) {
                pow *= 10
            }
        }
        println('\n')
    }
}
