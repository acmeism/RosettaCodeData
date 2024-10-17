// version 1.1.2

const val MAX = 12

var sp = CharArray(0)
val count = IntArray(MAX)
var pos = 0

fun factSum(n: Int): Int {
    var s = 0
    var x = 0
    var f = 1
    while (x < n) {
        f *= ++x
        s += f
    }
    return s
}

fun r(n: Int): Boolean {
    if (n == 0) return false
    val c = sp[pos - n]
    if (--count[n] == 0) {
        count[n] = n
        if (!r(n - 1)) return false
    }
    sp[pos++] = c
    return true
}

fun superPerm(n: Int) {
    pos = n
    val len = factSum(n)
    if (len > 0) sp = CharArray(len)
    for (i in 0..n) count[i] = i
    for (i in 1..n) sp[i - 1] = '0' + i
    while (r(n)) {}
}

fun main(args: Array<String>) {
    for (n in 0 until MAX) {
        superPerm(n)
        println("superPerm(${"%2d".format(n)}) len = ${sp.size}")
    }
}
