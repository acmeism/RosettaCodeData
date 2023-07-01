fun pancake(n: Int): Int {
    var gap = 2
    var sum = 2
    var adj = -1
    while (sum < n) {
        adj++
        gap = gap * 2 - 1
        sum += gap
    }
    return n + adj
}

fun main() {
    (1 .. 20).map {"p(%2d) = %2d".format(it, pancake(it))}
    val lines = results.chunked(5).map { it.joinToString("  ") }
    lines.forEach { println(it) }
}
