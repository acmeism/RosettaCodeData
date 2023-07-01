// version 1.1.3

typealias Vector = DoubleArray
typealias Matrix = Array<Vector>

fun Matrix.transpose(): Matrix {
    val rows = this.size
    val cols = this[0].size
    val trans = Matrix(cols) { Vector(rows) }
    for (i in 0 until cols) {
        for (j in 0 until rows) trans[i][j] = this[j][i]
    }
    return trans
}

// Alternate version
typealias Matrix<T> = List<List<T>>
fun <T> Matrix<T>.transpose(): Matrix<T> {
    return (0 until this[0].size).map { x ->
        (this.indices).map { y ->
            this[y][x]
        }
    }
}
