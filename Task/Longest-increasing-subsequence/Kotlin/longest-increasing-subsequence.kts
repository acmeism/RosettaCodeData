// version 1.1.0

fun longestIncreasingSubsequence(x: IntArray): IntArray =
    when (x.size) {
        0    -> IntArray(0)
        1    -> x
        else -> {
            val n = x.size
            val p = IntArray(n)
            val m = IntArray(n + 1)
            var len = 0
            for (i in 0 until n) {
                var lo = 1
                var hi = len
                while (lo <= hi) {
                    val mid = Math.ceil((lo + hi) / 2.0).toInt()
                    if (x[m[mid]] < x[i]) lo = mid + 1
                    else hi = mid - 1
                }
                val newLen = lo
                p[i] = m[newLen - 1]
                m[newLen] = i
                if (newLen > len) len = newLen
            }
            val s = IntArray(len)
            var k = m[len]
            for (i in len - 1 downTo 0) {
                s[i] = x[k]
                k = p[k]
            }
            s
        }
    }

fun main(args: Array<String>) {
    val lists = listOf(
        intArrayOf(3, 2, 6, 4, 5, 1),
        intArrayOf(0, 8, 4, 12, 2, 10, 6, 14, 1, 9, 5, 13, 3, 11, 7, 15)
    )
    lists.forEach { println(longestIncreasingSubsequence(it).asList()) }
}
