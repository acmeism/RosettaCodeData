// version 1.1.51

/* in place sort */
fun IntArray.sortDisjoint(indices: Set<Int>) {
    val sortedSubset = this.filterIndexed { index, _ -> index in indices }.sorted()
    if (sortedSubset.size < indices.size)
        throw IllegalArgumentException("Argument set contains out of range indices")
    indices.sorted().forEachIndexed { index, value -> this[value] = sortedSubset[index] }
}

fun main(args: Array<String>) {
    val values = intArrayOf(7, 6, 5, 4, 3, 2, 1, 0)
    val indices = setOf(6, 1, 7)
    println("Original array : ${values.asList()} sorted on indices $indices")
    values.sortDisjoint(indices)
    println("Sorted array   : ${values.asList()}")
}
