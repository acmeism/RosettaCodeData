// version 1.1.3

fun castOut(base: Int, start: Int, end: Int): List<Int> {
    val b = base - 1
    val ran = (0 until b).filter { it % b == (it * it) % b }
    var x = start / b
    val result = mutableListOf<Int>()
    while (true) {
        for (n in ran) {
            val k = b * x + n
            if (k < start) continue
            if (k > end) return result
            result.add(k)
        }
        x++
    }
}

fun main(args: Array<String>) {
    println(castOut(16, 1, 255))
    println()
    println(castOut(10, 1, 99))
    println()
    println(castOut(17, 1, 288))
}
