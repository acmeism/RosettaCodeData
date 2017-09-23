// version 1.1.0

fun <T: Comparable<T>> gnomeSort(a: Array<T>, ascending: Boolean = true) {
    var i = 1
    var j = 2
    while (i < a.size)
        if (ascending && (a[i - 1] <= a[i]) ||
           !ascending && (a[i - 1] >= a[i]))
            i = j++
        else {
            val temp = a[i - 1]
            a[i - 1] = a[i]
            a[i--] = temp
            if (i == 0) i = j++
        }
}

fun main(args: Array<String>) {
    val array = arrayOf(100, 2, 56, 200, -52, 3, 99, 33, 177, -199)
    println("Original      : ${array.asList()}")
    gnomeSort(array)
    println("Sorted (asc)  : ${array.asList()}")
    gnomeSort(array, false)
    println("Sorted (desc) : ${array.asList()}")
}
