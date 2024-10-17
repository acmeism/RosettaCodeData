fun pancakeSort(a: IntArray) {
    /** Returns the index of the highest number in the range 0 until n. */
    fun indexOfMax(n: Int): Int = (0 until n).maxByOrNull{ a[it] }!!

    /** Flips the elements in the range 0 .. n. */
    fun flip(index: Int) {
        a.reverse(0, index + 1)
    }

    for (n in a.size downTo 2) {  // successively reduce size of array by 1
        val index = indexOfMax(n) // find index of largest
        if (index != n - 1) {     // if it's not already at the end
            if (index > 0) {      // if it's not already at the beginning
                flip(index)       // move largest to beginning
                println("${a.contentToString()} after flipping first ${index + 1}")
            }
            flip(n - 1)           // move largest to end
            println("${a.contentToString()} after flipping first $n")
        }
    }
}

fun main() {
    val a = intArrayOf(7, 6, 9, 2, 4, 8, 1, 3, 5)
    println("${a.contentToString()} initially")
    pancakeSort(a)
}
