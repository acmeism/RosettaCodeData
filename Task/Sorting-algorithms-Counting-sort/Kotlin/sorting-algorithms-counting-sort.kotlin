// version 1.1.0

fun countingSort(array: IntArray) {
    if (array.isEmpty()) return
    val min = array.min()!!
    val max = array.max()!!
    val count = IntArray(max - min + 1)  // all elements zero by default
    for (number in array) count[number - min]++
    var z = 0
    for (i in min..max)
        while (count[i - min] > 0) {
            array[z++] = i
            count[i - min]--
        }
}

fun main(args: Array<String>) {
    val array = intArrayOf(4, 65, 2, -31, 0, 99, 2, 83, 782, 1)
    println("Original : ${array.asList()}")
    countingSort(array)
    println("Sorted   : ${array.asList()}")
}
