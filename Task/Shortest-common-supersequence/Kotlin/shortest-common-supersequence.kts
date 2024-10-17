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

fun scs(u: String, v: String): String{
    val lcs = lcs(u, v)
    var ui = 0
    var vi = 0
    val sb = StringBuilder()
    for (i in 0 until lcs.length) {
        while (ui < u.length && u[ui] != lcs[i]) sb.append(u[ui++])
        while (vi < v.length && v[vi] != lcs[i]) sb.append(v[vi++])
        sb.append(lcs[i])
        ui++; vi++
    }
    if (ui < u.length) sb.append(u.substring(ui))
    if (vi < v.length) sb.append(v.substring(vi))
    return sb.toString()
}

fun main(args: Array<String>) {
    val u = "abcbdab"
    val v = "bdcaba"
    println(scs(u, v))
}
