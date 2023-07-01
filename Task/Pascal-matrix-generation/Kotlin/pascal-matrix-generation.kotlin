// version 1.1.3

fun binomial(n: Int, k: Int): Int {
    if (n < k) return 0
    if (n == 0 || k == 0) return 1
    val num = (k + 1..n).fold(1) { acc, i -> acc * i }
    val den = (2..n - k).fold(1) { acc, i -> acc * i }
    return num / den
}

fun pascalUpperTriangular(n: Int) = List(n) { i -> IntArray(n) { j -> binomial(j, i) } }

fun pascalLowerTriangular(n: Int) = List(n) { i -> IntArray(n) { j -> binomial(i, j) } }

fun pascalSymmetric(n: Int)       = List(n) { i -> IntArray(n) { j -> binomial(i + j, i) } }

fun printMatrix(title: String, m: List<IntArray>) {
    val n = m.size
    println(title)
    print("[")
    for (i in 0 until n) {
        if (i > 0) print(" ")
        print(m[i].contentToString())
        if (i < n - 1) println(",") else println("]\n")
    }
}

fun main(args: Array<String>) {
    printMatrix("Pascal upper-triangular matrix", pascalUpperTriangular(5))
    printMatrix("Pascal lower-triangular matrix", pascalLowerTriangular(5))
    printMatrix("Pascal symmetric matrix", pascalSymmetric(5))
}
