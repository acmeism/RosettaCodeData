// version 1.1.2

fun leonardo(n: Int, l0: Int = 1, l1: Int = 1, add: Int = 1): IntArray {
    val leo = IntArray(n)
    leo[0] = l0
    leo[1] = l1
    for (i in 2 until n) leo[i] = leo[i - 1] + leo[i - 2] + add
    return leo
}

fun main(args: Array<String>) {
    println("The first 25 Leonardo numbers with L[0] = 1, L[1] = 1 and add number = 1 are:")
    println(leonardo(25).joinToString(" "))
    println("\nThe first 25 Leonardo numbers with L[0] = 0, L[1] = 1 and add number = 0 are:")
    println(leonardo(25, 0, 1, 0).joinToString(" "))
}
