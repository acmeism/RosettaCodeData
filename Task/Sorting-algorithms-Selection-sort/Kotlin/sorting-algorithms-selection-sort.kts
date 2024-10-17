fun <T : Comparable<T>> Array<T>.selection_sort() {
    for (i in 0..size - 2) {
        var k = i
        for (j in i + 1..size - 1)
            if (this[j] < this[k])
                k = j

        if (k != i) {
            val tmp = this[i]
            this[i] = this[k]
            this[k] = tmp
        }
    }
}

fun main(args: Array<String>) {
    val i = arrayOf(4, 9, 3, -2, 0, 7, -5, 1, 6, 8)
    i.selection_sort()
    println(i.joinToString())

    val s = Array(i.size, { -i[it].toShort() })
    s.selection_sort()
    println(s.joinToString())

    val c = arrayOf('z', 'h', 'd', 'c', 'a')
    c.selection_sort()
    println(c.joinToString())
}
