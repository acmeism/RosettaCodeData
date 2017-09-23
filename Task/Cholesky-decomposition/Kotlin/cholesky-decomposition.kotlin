// version 1.0.6

fun cholesky(a: DoubleArray): DoubleArray {
    val n = Math.sqrt(a.size.toDouble()).toInt()
    val l = DoubleArray(a.size)
    var s: Double
    for (i in 0 until n)
        for (j in 0 .. i) {
            s = 0.0
            for (k in 0 until j) s += l[i * n + k] * l[j * n + k]
            l[i * n + j] = when {
                (i == j) -> Math.sqrt(a[i * n + i] - s)
                else     -> 1.0 / l[j * n + j] * (a[i * n + j] - s)
            }
        }
    return l
}

fun showMatrix(a: DoubleArray) {
    val n = Math.sqrt(a.size.toDouble()).toInt()
    for (i in 0 until n) {
        for (j in 0 until n) print("%8.5f ".format(a[i * n + j]))
        println()
    }
}

fun main(args: Array<String>) {
    val m1 = doubleArrayOf(25.0, 15.0, -5.0,
                           15.0, 18.0,  0.0,
                           -5.0,  0.0, 11.0)
    val c1 = cholesky(m1)
    showMatrix(c1)
    println()
    val m2 = doubleArrayOf(18.0, 22.0,  54.0,  42.0,
                           22.0, 70.0,  86.0,  62.0,
                           54.0, 86.0, 174.0, 134.0,
                           42.0, 62.0, 134.0, 106.0)
    val c2 = cholesky(m2)
    showMatrix(c2)
}
