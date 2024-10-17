class BellTriangle(n: Int) {
    private val arr: Array<Int>

    init {
        val length = n * (n + 1) / 2
        arr = Array(length) { 0 }

        set(1, 0, 1)
        for (i in 2..n) {
            set(i, 0, get(i - 1, i - 2))
            for (j in 1 until i) {
                val value = get(i, j - 1) + get(i - 1, j - 1)
                set(i, j, value)
            }
        }
    }

    private fun index(row: Int, col: Int): Int {
        require(row > 0)
        require(col >= 0)
        require(col < row)
        return row * (row - 1) / 2 + col
    }

    operator fun get(row: Int, col: Int): Int {
        val i = index(row, col)
        return arr[i]
    }

    private operator fun set(row: Int, col: Int, value: Int) {
        val i = index(row, col)
        arr[i] = value
    }
}

fun main() {
    val rows = 15
    val bt = BellTriangle(rows)

    println("First fifteen Bell numbers:")
    for (i in 1..rows) {
        println("%2d: %d".format(i, bt[i, 0]))
    }

    for (i in 1..10) {
        print("${bt[i, 0]}")
        for (j in 1 until i) {
            print(", ${bt[i, j]}")
        }
        println()
    }
}
