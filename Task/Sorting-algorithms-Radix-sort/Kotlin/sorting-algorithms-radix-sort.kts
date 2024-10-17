// version 1.1.2

fun radixSort(original: IntArray): IntArray {
    var old = original // Need this to be mutable
    // Loop for every bit in the integers
    for (shift in 31 downTo 0) {
        val tmp = IntArray(old.size)  // The array to put the partially sorted array into
        var j = 0                     // The number of 0s
        // Move the 0s to the new array, and the 1s to the old one
        for (i in 0 until old.size) {
            // If there is a 1 in the bit we are testing, the number will be negative
            val move = (old[i] shl shift) >= 0
            // If this is the last bit, negative numbers are actually lower
            val toBeMoved = if (shift == 0) !move else move
            if (toBeMoved)
                tmp[j++] = old[i]
            else {
                // It's a 1, so stick it in the old array for now
                old[i - j] = old[i]
            }
        }
        // Copy over the 1s from the old array
        for (i in j until tmp.size) tmp[i] = old[i - j]
        // And now the tmp array gets switched for another round of sorting
        old = tmp
    }
    return old
}

fun main(args: Array<String>) {
    val arrays = arrayOf(
        intArrayOf(170, 45, 75, -90, -802, 24, 2, 66),
        intArrayOf(-4, 5, -26, 58, -990, 331, 331, 990, -1837, 2028)
    )
    for (array in arrays) println(radixSort(array).contentToString())
}
