import kotlin.math.abs

enum class Piece {
    Empty,
    Black,
    White,
}

typealias Position = Pair<Int, Int>

fun place(m: Int, n: Int, pBlackQueens: MutableList<Position>, pWhiteQueens: MutableList<Position>): Boolean {
    if (m == 0) {
        return true
    }
    var placingBlack = true
    for (i in 0 until n) {
        inner@
        for (j in 0 until n) {
            val pos = Position(i, j)
            for (queen in pBlackQueens) {
                if (queen == pos || !placingBlack && isAttacking(queen, pos)) {
                    continue@inner
                }
            }
            for (queen in pWhiteQueens) {
                if (queen == pos || placingBlack && isAttacking(queen, pos)) {
                    continue@inner
                }
            }
            placingBlack = if (placingBlack) {
                pBlackQueens.add(pos)
                false
            } else {
                pWhiteQueens.add(pos)
                if (place(m - 1, n, pBlackQueens, pWhiteQueens)) {
                    return true
                }
                pBlackQueens.removeAt(pBlackQueens.lastIndex)
                pWhiteQueens.removeAt(pWhiteQueens.lastIndex)
                true
            }
        }
    }
    if (!placingBlack) {
        pBlackQueens.removeAt(pBlackQueens.lastIndex)
    }
    return false
}

fun isAttacking(queen: Position, pos: Position): Boolean {
    return queen.first == pos.first
            || queen.second == pos.second
            || abs(queen.first - pos.first) == abs(queen.second - pos.second)
}

fun printBoard(n: Int, blackQueens: List<Position>, whiteQueens: List<Position>) {
    val board = MutableList(n * n) { Piece.Empty }

    for (queen in blackQueens) {
        board[queen.first * n + queen.second] = Piece.Black
    }
    for (queen in whiteQueens) {
        board[queen.first * n + queen.second] = Piece.White
    }
    for ((i, b) in board.withIndex()) {
        if (i != 0 && i % n == 0) {
            println()
        }
        if (b == Piece.Black) {
            print("B ")
        } else if (b == Piece.White) {
            print("W ")
        } else {
            val j = i / n
            val k = i - j * n
            if (j % 2 == k % 2) {
                print("• ")
            } else {
                print("◦ ")
            }
        }
    }
    println('\n')
}

fun main() {
    val nms = listOf(
        Pair(2, 1), Pair(3, 1), Pair(3, 2), Pair(4, 1), Pair(4, 2), Pair(4, 3),
        Pair(5, 1), Pair(5, 2), Pair(5, 3), Pair(5, 4), Pair(5, 5),
        Pair(6, 1), Pair(6, 2), Pair(6, 3), Pair(6, 4), Pair(6, 5), Pair(6, 6),
        Pair(7, 1), Pair(7, 2), Pair(7, 3), Pair(7, 4), Pair(7, 5), Pair(7, 6), Pair(7, 7)
    )
    for ((n, m) in nms) {
        println("$m black and $m white queens on a $n x $n board:")
        val blackQueens = mutableListOf<Position>()
        val whiteQueens = mutableListOf<Position>()
        if (place(m, n, blackQueens, whiteQueens)) {
            printBoard(n, blackQueens, whiteQueens)
        } else {
            println("No solution exists.\n")
        }
    }
}
