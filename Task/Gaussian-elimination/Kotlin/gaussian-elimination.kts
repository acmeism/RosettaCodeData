// version 1.1.51

val ta = arrayOf(
    doubleArrayOf(1.00, 0.00, 0.00, 0.00, 0.00, 0.00),
    doubleArrayOf(1.00, 0.63, 0.39, 0.25, 0.16, 0.10),
    doubleArrayOf(1.00, 1.26, 1.58, 1.98, 2.49, 3.13),
    doubleArrayOf(1.00, 1.88, 3.55, 6.70, 12.62, 23.80),
    doubleArrayOf(1.00, 2.51, 6.32, 15.88, 39.90, 100.28),
    doubleArrayOf(1.00, 3.14, 9.87, 31.01, 97.41, 306.02)
)

val tb = doubleArrayOf(-0.01, 0.61, 0.91, 0.99, 0.60, 0.02)

val tx = doubleArrayOf(
    -0.01, 1.602790394502114, -1.6132030599055613,
    1.2454941213714368, -0.4909897195846576, 0.065760696175232
)

const val EPSILON = 1e-14  // tolerance required

fun gaussPartial(a0: Array<DoubleArray>, b0: DoubleArray): DoubleArray {
    val m = b0.size
    val a = Array(m) { DoubleArray(m) }
    for ((i, ai) in a0.withIndex()) {
        val row = ai.copyOf(m + 1)
        row[m] = b0[i]
        a[i] = row
    }
    for (k in 0 until a.size) {
        var iMax = 0
        var max = -1.0
        for (i in k until m) {
            val row = a[i]
            // compute scale factor s = max abs in row
            var s = -1.0
            for (j in k until m) {
                val e = Math.abs(row[j])
                if (e > s) s = e
            }
            // scale the abs used to pick the pivot
            val abs = Math.abs(row[k]) / s
            if (abs > max) {
                iMax = i
                max = abs
            }
        }
        if (a[iMax][k] == 0.0) {
            throw RuntimeException("Matrix is singular.")
        }
        val tmp = a[k]
        a[k] = a[iMax]
        a[iMax] = tmp
        for (i in k + 1 until m) {
            for (j in k + 1..m) {
                a[i][j] -= a[k][j] * a[i][k] / a[k][k]
            }
            a[i][k] = 0.0
        }
    }
    val x = DoubleArray(m)
    for (i in m - 1 downTo 0) {
        x[i] = a[i][m]
        for (j in i + 1 until m) {
            x[i] -= a[i][j] * x[j]
        }
        x[i] /= a[i][i]
    }
    return x
}

fun main(args: Array<String>) {
    val x = gaussPartial(ta, tb)
    println(x.asList())
    for ((i, xi) in x.withIndex()) {
        if (Math.abs(tx[i] - xi) > EPSILON) {
            println("Out of tolerance.")
            println("Expected values are ${tx.asList()}")
            return
        }
    }
}
