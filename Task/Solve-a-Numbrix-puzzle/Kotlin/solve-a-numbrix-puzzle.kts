// version 1.2.0

val example1 = listOf(
    "00,00,00,00,00,00,00,00,00",
    "00,00,46,45,00,55,74,00,00",
    "00,38,00,00,43,00,00,78,00",
    "00,35,00,00,00,00,00,71,00",
    "00,00,33,00,00,00,59,00,00",
    "00,17,00,00,00,00,00,67,00",
    "00,18,00,00,11,00,00,64,00",
    "00,00,24,21,00,01,02,00,00",
    "00,00,00,00,00,00,00,00,00"
)

val example2 = listOf(
    "00,00,00,00,00,00,00,00,00",
    "00,11,12,15,18,21,62,61,00",
    "00,06,00,00,00,00,00,60,00",
    "00,33,00,00,00,00,00,57,00",
    "00,32,00,00,00,00,00,56,00",
    "00,37,00,01,00,00,00,73,00",
    "00,38,00,00,00,00,00,72,00",
    "00,43,44,47,48,51,76,77,00",
    "00,00,00,00,00,00,00,00,00"
)

val moves = listOf(1 to 0, 0 to 1, -1 to 0, 0 to -1)

lateinit var board: List<String>
lateinit var grid: List<IntArray>
lateinit var clues: IntArray
var totalToFill = 0

fun solve(r: Int, c: Int, count: Int, nextClue: Int): Boolean {
    if (count > totalToFill) return true
    val back = grid[r][c]
    if (back != 0 && back != count) return false
    if (back == 0 && nextClue < clues.size && clues[nextClue] == count) {
        return false
    }
    var nextClue2 = nextClue
    if (back == count) nextClue2++
    grid[r][c] = count
    for (m in moves) {
        if (solve(r + m.second, c + m.first, count + 1, nextClue2)) return true
    }
    grid[r][c] = back
    return false
}

fun printResult(n: Int) {
    println("Solution for example $n:")
    for (row in grid) {
        for (i in row) {
            if (i == -1) continue
            print("%2d ".format(i))
        }
        println()
    }
}

fun main(args: Array<String>) {
    for ((n, ex) in listOf(example1, example2).withIndex()) {
        board = ex
        val nRows = board.size + 2
        val nCols = board[0].split(",").size + 2
        var startRow = 0
        var startCol = 0
        grid = List(nRows) { IntArray(nCols) { -1 } }
        totalToFill = (nRows - 2) * (nCols - 2)
        val lst = mutableListOf<Int>()
        for (r in 0 until nRows) {
            if (r in 1 until nRows - 1) {
                val row = board[r - 1].split(",")
                for (c in 1 until nCols - 1) {
                    val value = row[c - 1].toInt()
                    if (value > 0) lst.add(value)
                    if (value == 1) {
                        startRow = r
                        startCol = c
                    }
                    grid[r][c] = value
                }
            }
        }
        lst.sort()
        clues = lst.toIntArray()
        if (solve(startRow, startCol, 1, 0)) printResult(n + 1)
    }
}
