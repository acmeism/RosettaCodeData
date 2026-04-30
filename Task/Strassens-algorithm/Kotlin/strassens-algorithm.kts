class Matrix(val data: List<List<Double>>) {
    val rows: Int = data.size
    val cols: Int = if (rows > 0) data[0].size else 0

    // Remove the explicit getter methods since Kotlin generates them automatically
    // fun getRows(): Int = rows  // Remove this
    // fun getCols(): Int = cols  // Remove this

    fun validateDimensions(other: Matrix) {
        if (rows != other.rows || cols != other.cols) {
            throw RuntimeException("Matrices must have the same dimensions.")
        }
    }

    fun validateMultiplication(other: Matrix) {
        if (cols != other.rows) {
            throw RuntimeException("Cannot multiply these matrices.")
        }
    }

    fun validateSquarePowerOfTwo() {
        if (rows != cols) {
            throw RuntimeException("Matrix must be square.")
        }
        if (rows == 0 || (rows and (rows - 1)) != 0) {
            throw RuntimeException("Size of matrix must be a power of two.")
        }
    }

    fun add(other: Matrix): Matrix {
        validateDimensions(other)

        val resultData = mutableListOf<MutableList<Double>>()
        for (i in 0 until rows) {
            val row = mutableListOf<Double>()
            for (j in 0 until cols) {
                row.add(data[i][j] + other.data[i][j])
            }
            resultData.add(row)
        }

        return Matrix(resultData)
    }

    fun subtract(other: Matrix): Matrix {
        validateDimensions(other)

        val resultData = mutableListOf<MutableList<Double>>()
        for (i in 0 until rows) {
            val row = mutableListOf<Double>()
            for (j in 0 until cols) {
                row.add(data[i][j] - other.data[i][j])
            }
            resultData.add(row)
        }

        return Matrix(resultData)
    }

    fun multiply(other: Matrix): Matrix {
        validateMultiplication(other)

        val resultData = mutableListOf<MutableList<Double>>()
        for (i in 0 until rows) {
            val row = mutableListOf<Double>()
            for (j in 0 until other.cols) {
                var sum = 0.0
                for (k in 0 until cols) {  // Changed from other.rows to cols
                    sum += data[i][k] * other.data[k][j]
                }
                row.add(sum)
            }
            resultData.add(row)
        }

        return Matrix(resultData)
    }

    override fun toString(): String {
        val sb = StringBuilder()
        for (row in data) {
            sb.append("[")
            for (i in row.indices) {
                sb.append(row[i])
                if (i < row.size - 1) {
                    sb.append(", ")
                }
            }
            sb.append("]\n")
        }
        return sb.toString()
    }

    fun toStringWithPrecision(p: Int): String {
        val sb = StringBuilder()
        val pow = Math.pow(10.0, p.toDouble())

        for (row in data) {
            sb.append("[")
            for (i in row.indices) {
                val r = Math.round(row[i] * pow) / pow
                var formatted = String.format("%.${p}f", r)

                if (formatted == "-0${if (p > 0) "." + "0".repeat(p) else ""}") {
                    formatted = "0${if (p > 0) "." + "0".repeat(p) else ""}"
                }

                sb.append(formatted)

                if (i < row.size - 1) {
                    sb.append(", ")
                }
            }
            sb.append("]\n")
        }
        return sb.toString()
    }

    companion object {
        private fun getParams(r: Int, c: Int): Array<IntArray> {
            return arrayOf(
                intArrayOf(0, r, 0, c, 0, 0),
                intArrayOf(0, r, c, 2 * c, 0, c),
                intArrayOf(r, 2 * r, 0, c, r, 0),
                intArrayOf(r, 2 * r, c, 2 * c, r, c)
            )
        }

        fun fromQuarters(q: Array<Matrix>): Matrix {
            val r = q[0].rows
            val c = q[0].cols
            val p = getParams(r, c)
            val rows = r * 2
            val cols = c * 2

            val mData = mutableListOf<MutableList<Double>>()
            for (i in 0 until rows) {
                val row = mutableListOf<Double>()
                for (j in 0 until cols) {
                    row.add(0.0)
                }
                mData.add(row)
            }

            for (k in 0 until 4) {
                for (i in p[k][0] until p[k][1]) {
                    for (j in p[k][2] until p[k][3]) {
                        mData[i][j] = q[k].data[i - p[k][4]][j - p[k][5]]
                    }
                }
            }

            return Matrix(mData)
        }
    }

    fun toQuarters(): Array<Matrix> {
        val r = rows / 2
        val c = cols / 2
        val p = Companion.getParams(r, c)
        val quarters = arrayOfNulls<Matrix>(4)

        for (k in 0 until 4) {
            val qData = mutableListOf<MutableList<Double>>()
            for (i in 0 until r) {
                val row = mutableListOf<Double>()
                for (j in 0 until c) {
                    row.add(0.0)
                }
                qData.add(row)
            }

            for (i in p[k][0] until p[k][1]) {
                for (j in p[k][2] until p[k][3]) {
                    qData[i - p[k][4]][j - p[k][5]] = data[i][j]
                }
            }
            quarters[k] = Matrix(qData)
        }

        @Suppress("UNCHECKED_CAST")
        return quarters as Array<Matrix>
    }

    fun strassen(other: Matrix): Matrix {
        validateSquarePowerOfTwo()
        other.validateSquarePowerOfTwo()
        if (rows != other.rows || cols != other.cols) {
            throw RuntimeException("Matrices must be square and of equal size for Strassen multiplication.")
        }

        if (rows == 1) {
            return this.multiply(other)
        }

        val qa = toQuarters()
        val qb = other.toQuarters()

        val p1 = qa[1].subtract(qa[3]).strassen(qb[2].add(qb[3]))
        val p2 = qa[0].add(qa[3]).strassen(qb[0].add(qb[3]))
        val p3 = qa[0].subtract(qa[2]).strassen(qb[0].add(qb[1]))
        val p4 = qa[0].add(qa[1]).strassen(qb[3])
        val p5 = qa[0].strassen(qb[1].subtract(qb[3]))
        val p6 = qa[3].strassen(qb[2].subtract(qb[0]))
        val p7 = qa[2].add(qa[3]).strassen(qb[0])

        val q = arrayOfNulls<Matrix>(4)

        q[0] = p1.add(p2).subtract(p4).add(p6)
        q[1] = p4.add(p5)
        q[2] = p6.add(p7)
        q[3] = p2.subtract(p3).add(p5).subtract(p7)

        @Suppress("UNCHECKED_CAST")
        return Companion.fromQuarters(q as Array<Matrix>)
    }
}

fun main() {
    val aData = listOf(
        listOf(1.0, 2.0),
        listOf(3.0, 4.0)
    )
    val a = Matrix(aData)

    val bData = listOf(
        listOf(5.0, 6.0),
        listOf(7.0, 8.0)
    )
    val b = Matrix(bData)

    val cData = listOf(
        listOf(1.0, 1.0, 1.0, 1.0),
        listOf(2.0, 4.0, 8.0, 16.0),
        listOf(3.0, 9.0, 27.0, 81.0),
        listOf(4.0, 16.0, 64.0, 256.0)
    )
    val c = Matrix(cData)

    val dData = listOf(
        listOf(4.0, -3.0, 4.0 / 3.0, -1.0 / 4.0),
        listOf(-13.0 / 3.0, 19.0 / 4.0, -7.0 / 3.0, 11.0 / 24.0),
        listOf(3.0 / 2.0, -2.0, 7.0 / 6.0, -1.0 / 4.0),
        listOf(-1.0 / 6.0, 1.0 / 4.0, -1.0 / 6.0, 1.0 / 24.0)
    )
    val d = Matrix(dData)

    val eData = listOf(
        listOf(1.0, 2.0, 3.0, 4.0),
        listOf(5.0, 6.0, 7.0, 8.0),
        listOf(9.0, 10.0, 11.0, 12.0),
        listOf(13.0, 14.0, 15.0, 16.0)
    )
    val e = Matrix(eData)

    val fData = listOf(
        listOf(1.0, 0.0, 0.0, 0.0),
        listOf(0.0, 1.0, 0.0, 0.0),
        listOf(0.0, 0.0, 1.0, 0.0),
        listOf(0.0, 0.0, 0.0, 1.0)
    )
    val f = Matrix(fData)

    println("Using 'normal' matrix multiplication:")
    println("  a * b = ${a.multiply(b)}")
    println("\nUsing 'Strassen' matrix multiplication:")
    println("  a * b = ${a.strassen(b)}")


    println("Using 'normal' matrix multiplication:")
    println("  c * d = ${c.multiply(d).toStringWithPrecision(6)}")
    println("\nUsing 'Strassen' matrix multiplication:")
    println("  c * d = ${c.strassen(d).toStringWithPrecision(6)}")


    println("Using 'normal' matrix multiplication:")
    println("  e * f = ${e.multiply(f)}")
    println("\nUsing 'Strassen' matrix multiplication:")
    println("  e * f = ${e.strassen(f)}")

}
