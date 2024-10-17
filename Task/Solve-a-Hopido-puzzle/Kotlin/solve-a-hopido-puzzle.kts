// version 1.2.0

val board = listOf(
    ".00.00.",
    "0000000",
    "0000000",
    ".00000.",
    "..000..",
    "...0..."
)

val moves = listOf(
    -3 to 0, 0 to  3,  3 to 0,  0 to -3,
     2 to 2, 2 to -2, -2 to 2, -2 to -2
)

lateinit var grid: List<IntArray>
var totalToFill = 0

fun solve(r: Int, c: Int, count: Int): Boolean {
    if (count > totalToFill) return true
    val nbrs = neighbors(r, c)
    if (nbrs.isEmpty() && count != totalToFill) return false
    nbrs.sortBy { it[2] }
    for (nb in nbrs) {
        val rr = nb[0]
        val cc = nb[1]
        grid[rr][cc] = count
        if (solve(rr, cc, count + 1)) return true
        grid[rr][cc] = 0
    }
    return false
}

fun neighbors(r: Int, c: Int): MutableList<IntArray> {
    val nbrs = mutableListOf<IntArray>()
    for (m in moves) {
        val x = m.first
        val y = m.second
        if (grid[r + y][c + x] == 0) {
            val num = countNeighbors(r + y, c + x) - 1
            nbrs.add(intArrayOf(r + y, c + x, num))
        }
    }
    return nbrs
}

fun countNeighbors(r: Int, c: Int): Int {
    var num = 0
    for (m in moves)
        if (grid[r + m.second][c + m.first] == 0) num++
    return num
}

fun printResult() {
    for (row in grid) {
        for (i in row) {
            print(if (i == -1) "   " else "%2d ".format(i))
        }
        println()
    }
}

fun main(args: Array<String>) {
    val nRows = board.size + 6
    val nCols = board[0].length + 6
    grid = List(nRows) { IntArray(nCols) { -1} }
    for (r in 0 until nRows) {
        for (c in 3 until nCols - 3) {
            if (r in 3 until nRows - 3) {
                if (board[r - 3][c - 3] == '0') {
                    grid[r][c] = 0
                    totalToFill++
                }
            }
        }
    }
    var pos = -1
    var rr: Int
    var cc: Int
    do {
        do {
            pos++
            rr = pos / nCols
            cc = pos % nCols
        }
        while (grid[rr][cc] == -1)

        grid[rr][cc] = 1
        if (solve(rr, cc, 2)) break
        grid[rr][cc] = 0
    }
    while (pos < nRows * nCols)

    printResult()
}
