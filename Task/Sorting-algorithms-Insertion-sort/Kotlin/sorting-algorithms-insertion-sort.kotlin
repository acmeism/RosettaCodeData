fun insertionSort(array: IntArray) {
    for (index in 1 until array.size) {
        val value = array[index]
        var subIndex = index - 1
        while (subIndex >= 0 && array[subIndex] > value) {
            array[subIndex + 1] = array[subIndex]
            subIndex--
        }
        array[subIndex + 1] = value
    }
}

fun main(args: Array<String>) {
    val numbers = intArrayOf(5, 2, 3, 17, 12, 1, 8, 3, 4, 9, 7)

    fun printArray(message: String, array: IntArray) = with(array) {
        print("$message [")
        forEachIndexed { index, number ->
            print(if (index == lastIndex) number else "$number, ")
        }
        println("]")
    }

    printArray("Unsorted:", numbers)
    insertionSort(numbers)
    printArray("Sorted:", numbers)
}
