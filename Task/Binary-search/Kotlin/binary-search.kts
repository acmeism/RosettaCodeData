fun <T : Comparable<T>> Array<T>.iterativeBinarySearch(target: T): Int {
    var hi = size - 1
    var lo = 0
    while (hi >= lo) {
        val guess = lo + (hi - lo) / 2
        if (this[guess] > target) hi = guess - 1
        else if (this[guess] < target) lo = guess + 1
        else return guess
    }
    return -1
}

fun <T : Comparable<T>> Array<T>.recursiveBinarySearch(target: T, lo: Int, hi: Int): Int {
    if (hi < lo) return -1

    val guess = (hi + lo) / 2

    return if (this[guess] > target) recursiveBinarySearch(target, lo, guess - 1)
    else if (this[guess] < target) recursiveBinarySearch(target, guess + 1, hi)
    else guess
}

fun main(args: Array<String>) {
    val a = arrayOf(1, 3, 4, 5, 6, 7, 8, 9, 10)
    var target = 6
    var r = a.iterativeBinarySearch(target)
    println(if (r < 0) "$target not found" else "$target found at index $r")
    target = 250
    r = a.iterativeBinarySearch(target)
    println(if (r < 0) "$target not found" else "$target found at index $r")

    target = 6
    r = a.recursiveBinarySearch(target, 0, a.size)
    println(if (r < 0) "$target not found" else "$target found at index $r")
    target = 250
    r = a.recursiveBinarySearch(target, 0, a.size)
    println(if (r < 0) "$target not found" else "$target found at index $r")
}
