// version 1.1.3

fun deconv(g: DoubleArray, f: DoubleArray): DoubleArray {
    val fs = f.size
    val h = DoubleArray(g.size - fs + 1)
    for (n in h.indices) {
        h[n] = g[n]
        val lower = if (n >= fs) n - fs + 1 else 0
        for (i in lower until n) h[n] -= h[i] * f[n -i]
        h[n] /= f[0]
    }
    return h
}

fun main(args: Array<String>) {
    val h = doubleArrayOf(-8.0, -9.0, -3.0, -1.0, -6.0, 7.0)
    val f = doubleArrayOf(-3.0, -6.0, -1.0,  8.0, -6.0,  3.0, -1.0, -9.0,
                          -9.0,  3.0, -2.0,  5.0,  2.0, -2.0, -7.0, -1.0)
    val g = doubleArrayOf(24.0,  75.0, 71.0, -34.0,  3.0,  22.0, -45.0,
                          23.0, 245.0, 25.0,  52.0, 25.0, -67.0, -96.0,
                          96.0,  31.0, 55.0,  36.0, 29.0, -43.0,  -7.0)
    println("${h.map { it.toInt() }}")
    println("${deconv(g, f).map { it.toInt() }}")
    println()
    println("${f.map { it.toInt() }}")
    println("${deconv(g, h).map { it.toInt() }}")
}
