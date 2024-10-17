// Version 1.2.31

lateinit var m: List<IntArray>
lateinit var s: List<IntArray>

fun optimalMatrixChainOrder(dims: IntArray) {
    val n = dims.size - 1
    m = List(n) { IntArray(n) }
    s = List(n) { IntArray(n) }
    for (len in 1 until n) {
        for (i in 0 until n - len) {
            val j = i + len
            m[i][j] = Int.MAX_VALUE
            for (k in i until j) {
                val temp = dims[i] * dims [k + 1] * dims[j + 1]
                val cost = m[i][k] + m[k + 1][j] + temp
                if (cost < m[i][j]) {
                    m[i][j] = cost
                    s[i][j] = k
                }
            }
        }
    }
}

fun printOptimalChainOrder(i: Int, j: Int) {
    if (i == j)
        print("${(i + 65).toChar()}")
    else {
        print("(")
        printOptimalChainOrder(i, s[i][j])
        printOptimalChainOrder(s[i][j] + 1, j)
        print(")")
    }
}

fun main(args: Array<String>) {
    val dimsList = listOf(
        intArrayOf(5, 6, 3, 1),
        intArrayOf(1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2),
        intArrayOf(1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10)
    )
    for (dims in dimsList) {
        println("Dims  : ${dims.asList()}")
        optimalMatrixChainOrder(dims)
        print("Order : ")
        printOptimalChainOrder(0, s.size - 1)
        println("\nCost  : ${m[0][s.size - 1]}\n")
    }
}
