// version 1.1.2

/* returns x where (a * x) % b == 1 */
fun multInv(a: Int, b: Int): Int {
    if (b == 1) return 1
    var aa = a
    var bb = b
    var x0 = 0
    var x1 = 1
    while (aa > 1) {
        val q = aa / bb
        var t = bb
        bb = aa % bb
        aa = t
        t = x0
        x0 = x1 - q * x0
        x1 = t
    }
    if (x1 < 0) x1 += b
    return x1
}

fun chineseRemainder(n: IntArray, a: IntArray): Int {
    val prod = n.fold(1) { acc, i -> acc * i }
    var sum = 0
    for (i in 0 until n.size) {
        val p = prod / n[i]
        sum += a[i] * multInv(p, n[i]) * p
    }
    return sum % prod
}

fun main(args: Array<String>) {
    val n = intArrayOf(3, 5, 7)
    val a = intArrayOf(2, 3, 2)
    println(chineseRemainder(n, a))
}
