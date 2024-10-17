// version 1.1.2 (JVM)

typealias Matrix = Array<IntArray>

fun kroneckerProduct(a: Matrix, b: Matrix): Matrix {
    val m = a.size
    val n = a[0].size
    val p = b.size
    val q = b[0].size
    val rtn = m * p
    val ctn = n * q
    val r: Matrix = Array(rtn) { IntArray(ctn) } // all elements zero by default
    for (i in 0 until m)
        for (j in 0 until n)
            for (k in 0 until p)
                for (l in 0 until q)
                    r[p * i + k][q * j + l] = a[i][j] * b[k][l]
    return r
}

fun printMatrix(text: String, m: Matrix) {
    println(text)
    for (i in 0 until m.size) println(m[i].contentToString())
    println()
}

fun printAll(a: Matrix, b: Matrix, r: Matrix) {
    printMatrix("Matrix A:", a)
    printMatrix("Matrix B:", b)
    printMatrix("Kronecker product:", r)
}

fun main(args: Array<String>) {
    var a: Matrix
    var b: Matrix
    var r: Matrix
    a = arrayOf(
        intArrayOf(1, 2),
        intArrayOf(3, 4)
    )
    b = arrayOf(
        intArrayOf(0, 5),
        intArrayOf(6, 7)
    )
    r = kroneckerProduct(a, b)
    printAll(a, b, r)

    a = arrayOf(
        intArrayOf(0, 1, 0),
        intArrayOf(1, 1, 1),
        intArrayOf(0, 1, 0)
    )
    b = arrayOf(
        intArrayOf(1, 1, 1, 1),
        intArrayOf(1, 0, 0, 1),
        intArrayOf(1, 1, 1, 1)
    )
    r = kroneckerProduct(a, b)
    printAll(a, b, r)
}
