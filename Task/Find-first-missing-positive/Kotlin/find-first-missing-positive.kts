fun main() {
    val nums = listOf(
        intArrayOf(1, 2, 0),
        intArrayOf(3, 4, -1, 1),
        intArrayOf(7, 8, 9, 11, 12)
    )
    for (array in nums)
        println("${array.contentToString()}: ${smallestMissingPositive(array)}")
}

private fun smallestMissingPositive(array: IntArray): Int {
    val min = 1 // The smallest possible result
    val max = min + array.size // The largest possible result

    // Flags whether each number from min to max-1 is present in the array.
    // Also has one always-false element at the end in case all numbers are present.
    val present = BooleanArray(max - min + 1)

    for (num in array)
        if (num in min..max - 1)
            present[num - min] = true
    return present.indexOf(false) + min
}
