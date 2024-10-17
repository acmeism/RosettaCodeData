// Version 1.2.31

typealias Vector = DoubleArray
typealias Matrix = Array<Vector>

operator fun Matrix.times(other: Matrix): Matrix {
    val rows1 = this.size
    val cols1 = this[0].size
    val rows2 = other.size
    val cols2 = other[0].size
    require(cols1 == rows2)
    val result = Matrix(rows1) { Vector(cols2) }
    for (i in 0 until rows1) {
        for (j in 0 until cols2) {
            for (k in 0 until rows2) {
                result[i][j] += this[i][k] * other[k][j]
            }
        }
    }
    return result
}

fun Matrix.transpose(): Matrix {
    val rows = this.size
    val cols = this[0].size
    val trans = Matrix(cols) { Vector(rows) }
    for (i in 0 until cols) {
        for (j in 0 until rows) trans[i][j] = this[j][i]
    }
    return trans
}

fun Matrix.inverse(): Matrix {
    val len = this.size
    require(this.all { it.size == len }) { "Not a square matrix" }
    val aug = Array(len) { DoubleArray(2 * len) }
    for (i in 0 until len) {
        for (j in 0 until len) aug[i][j] = this[i][j]
        // augment by identity matrix to right
        aug[i][i + len] = 1.0
    }
    aug.toReducedRowEchelonForm()
    val inv = Array(len) { DoubleArray(len) }
    // remove identity matrix to left
    for (i in 0 until len) {
        for (j in len until 2 * len) inv[i][j - len] = aug[i][j]
    }
    return inv
}

fun Matrix.toReducedRowEchelonForm() {
    var lead = 0
    val rowCount = this.size
    val colCount = this[0].size
    for (r in 0 until rowCount) {
        if (colCount <= lead) return
        var i = r

        while (this[i][lead] == 0.0) {
            i++
            if (rowCount == i) {
                i = r
                lead++
                if (colCount == lead) return
            }
        }

        val temp = this[i]
        this[i] = this[r]
        this[r] = temp

        if (this[r][lead] != 0.0) {
           val div = this[r][lead]
           for (j in 0 until colCount) this[r][j] /= div
        }

        for (k in 0 until rowCount) {
            if (k != r) {
                val mult = this[k][lead]
                for (j in 0 until colCount) this[k][j] -= this[r][j] * mult
            }
        }

        lead++
    }
}

fun printVector(v: Vector) {
    println(v.asList())
    println()
}

fun multipleRegression(y: Vector, x: Matrix): Vector {
    val cy = (arrayOf(y)).transpose()  // convert 'y' to column vector
    val cx = x.transpose()             // convert 'x' to column vector array
    return ((x * cx).inverse() * x * cy).transpose()[0]
}

fun main(args: Array<String>) {
    var y = doubleArrayOf(1.0, 2.0, 3.0, 4.0, 5.0)
    var x = arrayOf(doubleArrayOf(2.0, 1.0, 3.0, 4.0, 5.0))
    var v = multipleRegression(y, x)
    printVector(v)

    y = doubleArrayOf(3.0, 4.0, 5.0)
    x = arrayOf(
        doubleArrayOf(1.0, 2.0, 1.0),
        doubleArrayOf(1.0, 1.0, 2.0)
    )
    v = multipleRegression(y, x)
    printVector(v)

    y = doubleArrayOf(52.21, 53.12, 54.48, 55.84, 57.20, 58.57, 59.93, 61.29,
                      63.11, 64.47, 66.28, 68.10, 69.92, 72.19, 74.46)

    val a = doubleArrayOf(1.47, 1.50, 1.52, 1.55, 1.57, 1.60, 1.63, 1.65, 1.68, 1.70,
                          1.73, 1.75, 1.78, 1.80, 1.83)
    x = arrayOf(DoubleArray(a.size) { 1.0 }, a, a.map { it * it }.toDoubleArray())
    v = multipleRegression(y, x)
    printVector(v)
}
