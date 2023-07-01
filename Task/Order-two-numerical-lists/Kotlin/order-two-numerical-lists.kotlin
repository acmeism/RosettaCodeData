// version 1.0.6

operator fun <T> List<T>.compareTo(other: List<T>): Int
    where T: Comparable<T>, T: Number {
    for (i in 0 until this.size) {
        if (other.size == i) return 1
        when {
            this[i] < other[i] -> return -1
            this[i] > other[i] -> return 1
        }
    }
    return if (this.size == other.size) 0 else -1
}

fun main(args: Array<String>) {
    val lists = listOf(
        listOf(1, 2, 3, 4, 5),
        listOf(1, 2, 1, 5, 2, 2),
        listOf(1, 2, 1, 5, 2),
        listOf(1, 2, 1, 5, 2),
        listOf(1, 2, 1, 3, 2),
        listOf(1, 2, 0, 4, 4, 0, 0, 0),
        listOf(1, 2, 0, 4, 4, 1, 0, 0)
    )
    for (i in 0 until lists.size) println("list${i + 1} : ${lists[i]}")
    println()
    for (i in 0 until lists.size - 1) println("list${i + 1} > list${i + 2} = ${lists[i] > lists[i + 1]}")
}
