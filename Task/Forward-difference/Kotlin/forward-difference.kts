// version 1.1.2

fun forwardDifference(ia: IntArray, order: Int): IntArray {
    if (order < 0) throw IllegalArgumentException("Order must be non-negative")
    if (order == 0) return ia
    val size = ia.size
    if (size == 0) return ia  // same empty array
    if (order >= size) return intArrayOf()  // new empty array
    var old = ia
    var new = old
    var count = order
    while (count-- >= 1) {
       new = IntArray(old.size - 1)
       for (i in 0 until new.size) new[i] = old[i + 1] - old[i]
       old = new
    }
    return new
}

fun printArray(ia: IntArray) {
    print("[")
    for (i in 0 until ia.size) {
        print("%5d".format(ia[i]))
        if (i < ia .size - 1) print(", ")
    }
    println("]")
}

fun main(args: Array<String>) {
    val ia = intArrayOf(90, 47, 58, 29, 22, 32, 55, 5, 55, 73)
    for (order in 0..ia.size) {
        val fd = forwardDifference(ia, order)
        print("%2d".format(order) + ":  ")
        printArray(fd)
    }
}
