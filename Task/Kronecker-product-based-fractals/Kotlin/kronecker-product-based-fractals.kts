// version 1.2.31

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

fun kroneckerPower(a: Matrix, n: Int): Matrix {
    var pow = a.copyOf()
    for (i in 1 until n) pow = kroneckerProduct(pow, a)
    return pow
}

fun printMatrix(text: String, m: Matrix) {
    println("$text fractal :\n")
    for (i in 0 until m.size) {
        for (j in 0 until m[0].size) {
            print(if (m[i][j] == 1) "*" else " ")
        }
        println()
    }
    println()
}

fun main(args: Array<String>) {
    var a = arrayOf(
        intArrayOf(0, 1, 0),
        intArrayOf(1, 1, 1),
        intArrayOf(0, 1, 0)
    )
    printMatrix("Vicsek", kroneckerPower(a, 4))

    a = arrayOf(
        intArrayOf(1, 1, 1),
        intArrayOf(1, 0, 1),
        intArrayOf(1, 1, 1)
    )
    printMatrix("Sierpinski carpet", kroneckerPower(a, 4))
}
