// version 1.1.3

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

fun printMatrix(m: Matrix) {
    for (i in 0 until m.size) println(m[i].contentToString())
}

fun main(args: Array<String>) {
    val m1 = arrayOf(
        doubleArrayOf(-1.0,  1.0,  4.0),
        doubleArrayOf( 6.0, -4.0,  2.0),
        doubleArrayOf(-3.0,  5.0,  0.0),
        doubleArrayOf( 3.0,  7.0, -2.0)
    )
    val m2 = arrayOf(
        doubleArrayOf(-1.0,  1.0,  4.0,  8.0),
        doubleArrayOf( 6.0,  9.0, 10.0,  2.0),
        doubleArrayOf(11.0, -4.0,  5.0, -3.0)
    )
    printMatrix(m1 * m2)
}
