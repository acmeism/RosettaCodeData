fun <T> swap(array: Array<T>, i: Int, j: Int) {
    val temp = array[i]
    array[i] = array[j]
    array[j] = temp
}

fun <T> cocktailSort(array: Array<T>) where T : Comparable<T> {
    var begin = 0
    var end = array.size
    if (end == 0) {
        return
    }
    --end
    while (begin < end) {
        var newBegin = end
        var newEnd = begin
        for (i in begin until end) {
            val c1 = array[i]
            val c2 = array[i + 1]
            if (c1 > c2) {
                swap(array, i, i + 1)
                newEnd = i
            }
        }
        end = newEnd
        for (i in end downTo begin + 1) {
            val c1 = array[i - 1]
            val c2 = array[i]
            if (c1 > c2) {
                swap(array, i, i - 1)
                newBegin = i
            }
        }
        begin = newBegin
    }
}

fun main() {
    val array: Array<Int> = intArrayOf(5, 1, -6, 12, 3, 13, 2, 4, 0, 15).toList().toTypedArray()

    println("before: ${array.contentToString()}")
    cocktailSort(array)
    println("after: ${array.contentToString()}")
}
