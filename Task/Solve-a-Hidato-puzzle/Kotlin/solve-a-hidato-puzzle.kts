// version 1.2.0

lateinit var board: List<IntArray>
lateinit var given: IntArray
lateinit var start: IntArray

fun setUp(input: List<String>) {
    val nRows = input.size
    val puzzle = List(nRows) { input[it].split(" ") }
    val nCols = puzzle[0].size
    val list = mutableListOf<Int>()
    board = List(nRows + 2) { IntArray(nCols + 2) { -1 } }
    for (r in 0 until nRows) {
        val row = puzzle[r]
        for (c in 0 until nCols) {
            val cell = row[c]
            if (cell == "_") {
                board[r + 1][c + 1] = 0
            }
            else if (cell != ".") {
                val value = cell.toInt()
                board[r + 1][c + 1] = value
                list.add(value)
                if (value == 1) start = intArrayOf(r + 1, c + 1)
            }
        }
    }
    list.sort()
    given = list.toIntArray()
}

fun solve(r: Int, c: Int, n: Int, next: Int): Boolean {
    if (n > given[given.lastIndex]) return true
    val back = board[r][c]
    if (back != 0 && back != n) return false
    if (back == 0 && given[next] == n) return false
    var next2 = next
    if (back == n) next2++
    board[r][c] = n
    for (i in -1..1)
        for (j in -1..1)
            if (solve(r + i, c + j, n + 1, next2)) return true
    board[r][c] = back
    return false
}

fun printBoard() {
    for (row in board) {
        for (c in row) {
            if (c == -1)
                print(" . ")
            else
                print(if (c > 0) "%2d ".format(c) else "__ ")
        }
        println()
    }
}

fun main(args: Array<String>) {
    var input = listOf(
        "_ 33 35 _ _ . . .",
        "_ _ 24 22 _ . . .",
        "_ _ _ 21 _ _ . .",
        "_ 26 _ 13 40 11 . .",
        "27 _ _ _ 9 _ 1 .",
        ". . _ _ 18 _ _ .",
        ". . . . _ 7 _ _",
        ". . . . . . 5 _"
    )
    setUp(input)
    printBoard()
    println("\nFound:")
    solve(start[0], start[1], 1, 0)
    printBoard()
}
