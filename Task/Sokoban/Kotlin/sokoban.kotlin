// version 1.2.0

import java.util.LinkedList

class Sokoban(board: List<String>) {
    val destBoard: String
    val currBoard: String
    val nCols = board[0].length
    var playerX = 0
    var playerY = 0

    init {
        val destBuf = StringBuilder()
        val currBuf = StringBuilder()
        for (r in 0 until board.size) {
            for (c in 0 until nCols) {
                val ch = board[r][c]
                destBuf.append(if (ch != '$' && ch != '@') ch else ' ')
                currBuf.append(if (ch != '.') ch else ' ')
                if (ch == '@') {
                    playerX = c
                    playerY = r
                }
            }
        }
        destBoard = destBuf.toString()
        currBoard = currBuf.toString()
    }

    fun move(x: Int, y: Int, dx: Int, dy: Int, trialBoard: String): String {
        val newPlayerPos = (y + dy) * nCols + x + dx
        if (trialBoard[newPlayerPos] != ' ') return ""
        val trial = trialBoard.toCharArray()
        trial[y * nCols + x] = ' '
        trial[newPlayerPos] = '@'
        return String(trial)
    }

    fun push(x: Int, y: Int, dx: Int, dy: Int, trialBoard: String): String {
        val newBoxPos = (y + 2 * dy) * nCols + x + 2 * dx
        if (trialBoard[newBoxPos] != ' ') return ""
        val trial = trialBoard.toCharArray()
        trial[y * nCols + x] = ' '
        trial[(y + dy) * nCols + x + dx] = '@'
        trial[newBoxPos] = '$'
        return String(trial)
    }

    fun isSolved(trialBoard: String): Boolean {
        for (i in 0 until trialBoard.length) {
            if ((destBoard[i] == '.') != (trialBoard[i] == '$')) return false
        }
        return true
    }

    fun solve(): String {
        data class Board(val cur: String, val sol: String, val x: Int, val y: Int)
        val dirLabels = listOf('u' to 'U', 'r' to 'R', 'd' to 'D', 'l' to 'L')
        val dirs = listOf(0 to -1, 1 to 0, 0 to 1, -1 to 0)
        val history = mutableSetOf<String>()
        history.add(currBoard)
        val open = LinkedList<Board>()
        open.add(Board(currBoard, "", playerX, playerY))

        while (!open.isEmpty()) {
            val (cur, sol, x, y) = open.poll()
            for (i in 0 until dirs.size) {
                var trial = cur
                val dx = dirs[i].first
                val dy = dirs[i].second

                // are we standing next to a box ?
                if (trial[(y + dy) * nCols + x + dx] == '$') {

                    // can we push it ?
                    trial = push(x, y, dx, dy, trial)
                    if (!trial.isEmpty()) {

                        // or did we already try this one ?
                        if (trial !in history) {
                            val newSol = sol + dirLabels[i].second
                            if (isSolved(trial)) return newSol
                            open.add(Board(trial, newSol, x + dx, y + dy))
                            history.add(trial)
                        }
                    }
                } // otherwise try changing position
                else {
                    trial = move(x, y, dx, dy, trial)
                    if (!trial.isEmpty() && trial !in history) {
                        val newSol = sol + dirLabels[i].first
                        open.add(Board(trial, newSol, x + dx, y + dy))
                        history.add(trial)
                    }
                }
            }
        }
        return "No solution"
    }
}

fun main(args: Array<String>) {
    val level = listOf(
        "#######",
        "#     #",
        "#     #",
        "#. #  #",
        "#. $$ #",
        "#.$$  #",
        "#.#  @#",
        "#######"
    )
    println(level.joinToString("\n"))
    println()
    println(Sokoban(level).solve())
}
