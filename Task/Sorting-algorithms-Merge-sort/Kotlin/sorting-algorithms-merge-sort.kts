fun mergeSort(list: List<Int>): List<Int> {
    if (list.size <= 1) {
        return list
    }

    val left = mutableListOf<Int>()
    val right = mutableListOf<Int>()

    val middle = list.size / 2
    list.forEachIndexed { index, number ->
        if (index < middle) {
            left.add(number)
        } else {
            right.add(number)
        }
    }

    fun merge(left: List<Int>, right: List<Int>): List<Int> = mutableListOf<Int>().apply {
        var indexLeft = 0
        var indexRight = 0

        while (indexLeft < left.size && indexRight < right.size) {
            if (left[indexLeft] <= right[indexRight]) {
                add(left[indexLeft])
                indexLeft++
            } else {
                add(right[indexRight])
                indexRight++
            }
        }

        while (indexLeft < left.size) {
            add(left[indexLeft])
            indexLeft++
        }

        while (indexRight < right.size) {
            add(right[indexRight])
            indexRight++
        }
    }

    return merge(mergeSort(left), mergeSort(right))
}

fun main(args: Array<String>) {
    val numbers = listOf(5, 2, 3, 17, 12, 1, 8, 3, 4, 9, 7)
    println("Unsorted: $numbers")
    println("Sorted: ${mergeSort(numbers)}")
}
