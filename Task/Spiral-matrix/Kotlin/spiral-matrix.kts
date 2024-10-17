// version 1.1.3

typealias Vector = IntArray
typealias Matrix = Array<Vector>

fun spiralMatrix(n: Int): Matrix {
    val result = Matrix(n) { Vector(n) }
    var pos = 0
    var count = n
    var value = -n
    var sum = -1
    do {
        value = -value / n
        for (i in 0 until count) {
            sum += value
            result[sum / n][sum % n] = pos++
        }
        value *= n
        count--
        for (i in 0 until count) {
            sum += value
            result[sum / n][sum % n] = pos++
        }
    }
    while (count > 0)
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
    printMatrix(spiralMatrix(5))
    printMatrix(spiralMatrix(10))
}
