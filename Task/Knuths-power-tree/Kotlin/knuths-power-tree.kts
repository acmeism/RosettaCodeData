// version 1.1.3

import java.math.BigDecimal

var p = mutableMapOf(1 to 0)
var lvl = mutableListOf(listOf(1))

fun path(n: Int): List<Int> {
    if (n == 0) return emptyList<Int>()
    while (n !in p) {
        val q = mutableListOf<Int>()
        for (x in lvl[0]) {
            for (y in path(x)) {
                if ((x + y) in p) break
                p[x + y] = x
                q.add(x + y)
            }
        }
        lvl[0] = q
    }
    return path(p[n]!!) + n
}

fun treePow(x: Double, n: Int): BigDecimal {
    val r = mutableMapOf(0 to BigDecimal.ONE, 1 to BigDecimal(x.toString()))
    var p = 0
    for (i in path(n)) {
        r[i] = r[i - p]!! * r[p]!!
        p = i
    }
    return r[n]!!
}

fun showPow(x: Double, n: Int, isIntegral: Boolean = true) {
    println("$n: ${path(n)}")
    val f = if (isIntegral) "%.0f" else "%f"
    println("${f.format(x)} ^ $n = ${f.format(treePow(x, n))}\n")
}

fun main(args: Array<String>) {
    for (n in 0..17) showPow(2.0, n)
    showPow(1.1, 81, false)
    showPow(3.0, 191)
}
