// version 1.1.2

fun <T : Comparable<T>> combSort(input: Array<T>) {
    var gap = input.size
    if (gap <= 1) return  // already sorted
    var swaps = false
    while (gap > 1 || swaps) {
        gap = (gap / 1.247331).toInt()
        if (gap < 1) gap = 1
        var i = 0
        swaps = false
        while (i + gap < input.size) {
            if (input[i] > input[i + gap]) {
                val tmp = input[i]
                input[i] = input[i + gap]
                input[i + gap] = tmp
                swaps = true
            }
            i++
        }
    }
}

fun main(args: Array<String>) {
    val ia = arrayOf(28, 44, 46, 24, 19, 2, 17, 11, 25, 4)
    println("Unsorted : ${ia.contentToString()}")
    combSort(ia)
    println("Sorted   : ${ia.contentToString()}")
    println()
    val ca = arrayOf('X', 'B', 'E', 'A', 'Z', 'M', 'S', 'L', 'Y', 'C')
    println("Unsorted : ${ca.contentToString()}")
    combSort(ca)
    println("Sorted   : ${ca.contentToString()}")
}
