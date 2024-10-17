// version 1.1.3

typealias Vector = IntArray
typealias Matrix = Array<Vector>

fun zigzagMatrix(n: Int): Matrix {
    val result = Matrix(n) { Vector(n) }
    var down = false
    var count = 0
    for (col in 0 until n) {
        if (down)
            for (row in 0..col) result[row][col - row] = count++
        else
            for (row in col downTo 0) result[row][col - row] = count++
        down = !down
    }
    for (row in 1 until n) {
        if (down)
           for (col in n - 1 downTo row) result[row + n - 1 - col][col] = count++
        else
           for (col in row until n) result[row + n - 1 - col][col] = count++
        down = !down
    }
    return result
}
fun printMatrix(m: Matrix) {
    for (i in 0 until m.size) {
        for (j in 0 until m.size) print("%2d ".format(m[i][j]))
        println()
    }
    println()
}

fun main(args: Array<String>) {
    printMatrix(zigzagMatrix(5))
    printMatrix(zigzagMatrix(10))
}
