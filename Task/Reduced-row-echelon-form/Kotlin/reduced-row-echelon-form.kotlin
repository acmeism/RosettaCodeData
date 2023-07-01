// version 1.1.51

typealias Matrix = Array<DoubleArray>

/* changes the matrix to RREF 'in place' */
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
            print("${"% 6.2f".format(this[r][c])}  ")
        }
        println()
    }

    println()
}

fun main(args: Array<String>) {
    val matrices = listOf(
        arrayOf(
            doubleArrayOf( 1.0, 2.0, -1.0, -4.0),
            doubleArrayOf( 2.0, 3.0, -1.0, -11.0),
            doubleArrayOf(-2.0, 0.0, -3.0,  22.0)
        ),
        arrayOf(
            doubleArrayOf(1.0,  2.0,  3.0,  4.0,  3.0,  1.0),
            doubleArrayOf(2.0,  4.0,  6.0,  2.0,  6.0,  2.0),
            doubleArrayOf(3.0,  6.0, 18.0,  9.0,  9.0, -6.0),
            doubleArrayOf(4.0,  8.0, 12.0, 10.0, 12.0,  4.0),
            doubleArrayOf(5.0, 10.0, 24.0, 11.0, 15.0, -4.0)
        )
    )

    for (m in matrices) {
        m.printf("Original matrix:")
        m.toReducedRowEchelonForm()
        m.printf("Reduced row echelon form:")
    }
}
