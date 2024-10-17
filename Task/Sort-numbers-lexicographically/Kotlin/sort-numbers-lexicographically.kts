// Version 1.2.51

fun lexOrder(n: Int): List<Int> {
    var first = 1
    var last = n
    if (n < 1) {
        first = n
        last = 1
    }
    return (first..last).map { it.toString() }.sorted().map { it.toInt() }
}

fun main(args: Array<String>) {
    println("In lexicographical order:\n")
    for (n in listOf(0, 5, 13, 21, -22)) {
        println("${"%3d".format(n)}: ${lexOrder(n)}")
    }
}
