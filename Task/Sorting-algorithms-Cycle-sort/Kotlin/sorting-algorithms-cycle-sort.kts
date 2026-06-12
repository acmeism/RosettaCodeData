// version 1.1.0

/** Sort an array in place and return the number of writes */
fun <T : Comparable<T>> cycleSort(array: Array<T>): Int {
    var writes = 0

    // Loop through the array to find cycles to rotate.
    for (cycleStart in 0 until array.size - 1) {
        var item = array[cycleStart]

        // Find where to put the item.
        var pos = cycleStart
        for (i in cycleStart + 1 until array.size) if (array[i] < item) pos++

        // If the item is already there, this is not a cycle.
        if (pos == cycleStart) continue

        // Otherwise, put the item there or right after any duplicates.
        while (item == array[pos]) pos++
        val temp = array[pos]
        array[pos] = item
        item = temp
        writes++

        // Rotate the rest of the cycle.
        while (pos != cycleStart) {
            // Find where to put the item.
            pos = cycleStart
            for (i in cycleStart + 1 until array.size) if (array[i] < item) pos++

            // Otherwise, put the item there or right after any duplicates.
            while (item == array[pos]) pos++
            val temp2 = array[pos]
            array[pos] = item
            item = temp2
            writes++
        }
    }
    return writes
}

fun <T : Comparable<T>> printResults(array: Array<T>) {
    println(array.asList())
    val writes = cycleSort(array)
    println("After sorting with $writes writes:")
    println(array.asList())
    println()
}

fun main(args: Array<String>) {
    val array = arrayOf(0, 1, 2, 2, 2, 2, 1, 9, 3, 5, 5, 8, 4, 7, 0, 6)
    printResults(array)
    val array2 = arrayOf(5, 0, 1, 2, 2, 3, 5, 1, 1, 0, 5, 6, 9, 8, 0, 1)
    printResults(array2)
    val array3 = "the quick brown fox jumps over the lazy dog".split(' ').toTypedArray()
    printResults(array3)
    val array4 = "sphinx of black quartz judge my vow".replace(" ", "").toCharArray().distinct().toTypedArray()
    printResults(array4)
}
