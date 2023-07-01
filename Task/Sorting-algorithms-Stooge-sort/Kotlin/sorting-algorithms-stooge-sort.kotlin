// version 1.1.0

fun stoogeSort(a: IntArray, i: Int, j: Int) {
    if (a[j] < a[i]) {
        val temp = a[j]
        a[j] = a[i]
        a[i] = temp
    }
    if (j - i > 1) {
        val t = (j - i + 1) / 3
        stoogeSort(a, i, j - t)
        stoogeSort(a, i + t, j)
        stoogeSort(a, i, j - t)
    }
}

fun main(args: Array<String>) {
    val a = intArrayOf(100, 2, 56, 200, -52, 3, 99, 33, 177, -199)
    println("Original : ${a.asList()}")
    stoogeSort(a, 0, a.size - 1)
    println("Sorted   : ${a.asList()}")
}
