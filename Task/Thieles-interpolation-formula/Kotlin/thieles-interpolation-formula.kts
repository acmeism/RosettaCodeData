// version 1.1.2

const val N = 32
const val N2 = N * (N - 1) / 2
const val STEP = 0.05

val xval = DoubleArray(N)
val tsin = DoubleArray(N)
val tcos = DoubleArray(N)
val ttan = DoubleArray(N)
val rsin = DoubleArray(N2) { Double.NaN }
val rcos = DoubleArray(N2) { Double.NaN }
val rtan = DoubleArray(N2) { Double.NaN }

fun rho(x: DoubleArray, y: DoubleArray, r: DoubleArray, i: Int, n: Int): Double {
    if (n < 0) return 0.0
    if (n == 0) return y[i]
    val idx = (N - 1 - n) * (N - n) / 2 + i
    if (r[idx].isNaN()) {
        r[idx] = (x[i] - x[i + n]) /
                 (rho(x, y, r, i, n - 1) - rho(x, y, r, i + 1, n - 1)) +
                  rho(x, y, r, i + 1, n - 2)
    }
    return r[idx]
}

fun thiele(x: DoubleArray, y: DoubleArray, r: DoubleArray, xin: Double, n: Int): Double {
    if (n > N - 1) return 1.0
    return rho(x, y, r, 0, n) - rho(x, y, r, 0, n - 2) +
           (xin - x[n]) / thiele(x, y, r, xin, n + 1)
}

fun main(args: Array<String>) {
    for (i in 0 until N) {
        xval[i] = i * STEP
        tsin[i] = Math.sin(xval[i])
        tcos[i] = Math.cos(xval[i])
        ttan[i] = tsin[i] / tcos[i]
    }
    println("%16.14f".format(6 * thiele(tsin, xval, rsin, 0.5, 0)))
    println("%16.14f".format(3 * thiele(tcos, xval, rcos, 0.5, 0)))
    println("%16.14f".format(4 * thiele(ttan, xval, rtan, 1.0, 0)))
}
