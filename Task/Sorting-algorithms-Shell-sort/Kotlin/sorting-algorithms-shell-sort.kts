// version 1.1.0

val gaps = listOf(701, 301, 132, 57, 23, 10, 4, 1)  // Marcin Ciura's gap sequence

fun shellSort(a: IntArray) {
    for (gap in gaps) {
        for (i in gap until a.size) {
            val temp = a[i]
            var j = i
            while (j >= gap && a[j - gap] > temp) {
                a[j] = a[j - gap]
                j -= gap
            }
            a[j] = temp
        }
    }
}

fun main(args: Array<String>) {
    val aa = arrayOf(
        intArrayOf(100, 2, 56, 200, -52, 3, 99, 33, 177, -199),
        intArrayOf(4, 65, 2, -31, 0, 99, 2, 83, 782, 1),
        intArrayOf(62, 83, 18, 53, 7, 17, 95, 86, 47, 69, 25, 28)
    )
    for (a in aa) {
        shellSort(a)
        println(a.joinToString(", "))
    }
}
