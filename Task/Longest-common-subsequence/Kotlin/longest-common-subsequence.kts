// version 1.1.2

fun lcs(x: String, y: String): String {
    if (x.length == 0 || y.length == 0) return ""
    val x1 = x.dropLast(1)
    val y1 = y.dropLast(1)
    if (x.last() == y.last()) return lcs(x1, y1) + x.last()
    val x2 = lcs(x, y1)
    val y2 = lcs(x1, y)
    return if (x2.length > y2.length) x2 else y2
}

fun main(args: Array<String>) {
    val x = "thisisatest"
    val y = "testing123testing"
    println(lcs(x, y))
}
