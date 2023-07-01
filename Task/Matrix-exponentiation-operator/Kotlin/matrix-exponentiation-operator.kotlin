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

fun identityMatrix(n: Int): Matrix {
    require(n >= 1)
    val ident = Matrix(n) { Vector(n) }
    for (i in 0 until n) ident[i][i] = 1.0
    return ident
}

infix fun Matrix.pow(n : Int): Matrix {
    require (n >= 0 && this.size == this[0].size)
    if (n == 0) return identityMatrix(this.size)
    if (n == 1) return this
    var pow = identityMatrix(this.size)
    var base = this
    var e = n
    while (e > 0) {
        if ((e and 1) == 1) pow *= base
        e = e shr 1
        base *= base
    }
    return pow
}

fun printMatrix(m: Matrix, n: Int) {
    println("** Power of $n **")
    for (i in 0 until m.size) println(m[i].contentToString())
    println()
}

fun main(args: Array<String>) {
    val m = arrayOf(
        doubleArrayOf(3.0, 2.0),
        doubleArrayOf(2.0, 1.0)
    )
    for (i in 0..10) printMatrix(m pow i, i)
}
