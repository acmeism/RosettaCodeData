// version 1.1.2

fun <T : Comparable<T>> strandSort(l: List<T>): List<T> {
    fun merge(left: MutableList<T>, right: MutableList<T>): MutableList<T> {
        val res = mutableListOf<T>()
        while (!left.isEmpty() && !right.isEmpty()) {
            if (left[0] <= right[0]) {
                res.add(left[0])
                left.removeAt(0)
            }
            else {
                res.add(right[0])
                right.removeAt(0)
            }
        }
        res.addAll(left)
        res.addAll(right)
        return res
    }

    var list = l.toMutableList()
    var result = mutableListOf<T>()
    while (!list.isEmpty()) {
        val sorted = mutableListOf(list[0])
        list.removeAt(0)
        val leftover = mutableListOf<T>()
        for (item in list) {
            if (sorted.last() <= item)
                sorted.add(item)
            else
                leftover.add(item)
        }
        result = merge(sorted, result)
        list = leftover
    }
    return result
}

fun main(args: Array<String>) {
    val l = listOf(-2, 0, -2, 5, 5, 3, -1, -3, 5, 5, 0, 2, -4, 4, 2)
    println(strandSort(l))
}
