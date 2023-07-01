// version 1.2.21

typealias Matrix = Array<DoubleArray>

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

fun Matrix.printf(title: String) {
    println(title)
    val rowCount = this.size
    val colCount = this[0].size

    for (r in 0 until rowCount) {
        for (c in 0 until colCount) {
            if (this[r][c] == -0.0) this[r][c] = 0.0  // get rid of negative zeros
            print("${"% 10.6f".format(this[r][c])}  ")
        }
        println()
    }

    println()
}

fun main(args: Array<String>) {
    val a = arrayOf(
        doubleArrayOf(1.0, 2.0, 3.0),
        doubleArrayOf(4.0, 1.0, 6.0),
        doubleArrayOf(7.0, 8.0, 9.0)
    )
    a.inverse().printf("Inverse of A is :\n")

    val b = arrayOf(
        doubleArrayOf( 2.0, -1.0,  0.0),
        doubleArrayOf(-1.0,  2.0, -1.0),
        doubleArrayOf( 0.0, -1.0,  2.0)
    )
    b.inverse().printf("Inverse of B is :\n")
}
