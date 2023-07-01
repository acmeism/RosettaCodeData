// version 1.0.6

fun <T> jortSort(a: Array<T>): Boolean {
    val b = a.copyOf()
    b.sort()
    for (i in 0 until a.size)
        if (a[i] != b[i]) return false
    return true
}

fun <T> printResults(a: Array<T>) {
    println(a.joinToString(" ") + " => " + if (jortSort(a)) "sorted" else "not sorted")
}

fun main(args: Array<String>) {
    val a = arrayOf(1, 2, 3, 4, 5)
    printResults(a)
    val b = arrayOf(2, 1, 3, 4, 5)
    printResults(b)
    println()
    val c = arrayOf('A', 'B', 'C', 'D', 'E')
    printResults(c)
    val d = arrayOf('C', 'D', 'A', 'E', 'B')
    printResults(d)
}
