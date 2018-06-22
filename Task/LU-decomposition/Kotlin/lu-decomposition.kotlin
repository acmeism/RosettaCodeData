// version 1.1.4-3

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

fun pivotize(m: Matrix): Matrix {
    val n = m.size
    val im = Array(n) { Vector(n) }
    for (i in 0 until n) im[i][i] = 1.0
    for (i in 0 until n) {
        var max = m[i][i]
        var row = i
        for (j in i until n) {
            if (m[j][i] > max) {
                max = m[j][i]
                row = j
            }
        }
        if (i != row) {
            val t = im[i]
            im[i] = im[row]
            im[row] = t
        }
    }
    return im
}

fun lu(a: Matrix): Array<Matrix> {
    val n = a.size
    val l = Array(n) { Vector(n) }
    val u = Array(n) { Vector(n) }
    val p = pivotize(a)
    val a2 = p * a

    for (j in 0 until n) {
        l[j][j] = 1.0
        for (i in 0 until j + 1) {
            var sum = 0.0
            for (k in 0 until i) sum += u[k][j] * l[i][k]
            u[i][j] = a2[i][j] - sum
        }
        for (i in j until n) {
            var sum2 = 0.0
            for(k in 0 until j) sum2 += u[k][j] * l[i][k]
            l[i][j] = (a2[i][j] - sum2) / u[j][j]
        }
    }
    return arrayOf(l, u, p)
}

fun printMatrix(title: String, m: Matrix, f: String) {
    val n = m.size
    println("\n$title\n")
    for (i in 0 until n) {
        for (j in 0 until n) print("${f.format(m[i][j])}  ")
        println()
    }
}

fun main(args: Array<String>) {
    val a1 = arrayOf(
        doubleArrayOf( 1.0,  3.0,  5.0),
        doubleArrayOf( 2.0,  4.0,  7.0),
        doubleArrayOf( 1.0,  1.0,  0.0)
    )
    val (l1, u1, p1) = lu(a1)
    println("EXAMPLE 1:-")
    printMatrix("A:", a1, "%1.0f")
    printMatrix("L:", l1, "% 7.5f")
    printMatrix("U:", u1, "% 8.5f")
    printMatrix("P:", p1, "%1.0f")

    val a2 = arrayOf(
        doubleArrayOf(11.0,  9.0, 24.0,  2.0),
        doubleArrayOf( 1.0,  5.0,  2.0,  6.0),
        doubleArrayOf( 3.0, 17.0, 18.0,  1.0),
        doubleArrayOf( 2.0,  5.0,  7.0,  1.0)
    )
    val (l2, u2, p2) = lu(a2)
    println("\nEXAMPLE 2:-")
    printMatrix("A:", a2, "%2.0f")
    printMatrix("L:", l2, "%7.5f")
    printMatrix("U:", u2, "%8.5f")
    printMatrix("P:", p2, "%1.0f")
}
