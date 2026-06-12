// version 1.1.3

data class Solution(val peg: Int, val over: Int, val land: Int)

var board = BooleanArray(16) { if (it == 0) false else true }

val jumpMoves = listOf(
    listOf(),
    listOf( 2 to  4,  3 to  6),
    listOf( 4 to  7,  5 to  9),
    listOf( 5 to  8,  6 to 10),
    listOf( 2 to  1,  5 to  6,  7 to 11,  8 to 13),
    listOf( 8 to 12,  9 to 14),
    listOf( 3 to  1,  5 to  4,  9 to 13, 10 to 15),
    listOf( 4 to  2,  8 to  9),
    listOf( 5 to  3,  9 to 10),
    listOf( 5 to  2,  8 to  7),
    listOf( 9 to  8),
    listOf(12 to 13),
    listOf( 8 to  5, 13 to 14),
    listOf( 8 to  4,  9 to  6, 12 to 11, 14 to 15),
    listOf( 9 to  5, 13 to 12),
    listOf(10 to  6, 14 to 13)
)

val solutions = mutableListOf<Solution>()

fun drawBoard() {
    val pegs = CharArray(16) { '-' }
    for (i in 1..15) if (board[i]) pegs[i] = "%X".format(i)[0]
    println("       %c".format(pegs[1]))
    println("      %c %c".format(pegs[2], pegs[3]))
    println("     %c %c %c".format(pegs[4], pegs[5], pegs[6]))
    println("    %c %c %c %c".format(pegs[7], pegs[8], pegs[9], pegs[10]))
    println("   %c %c %c %c %c".format(pegs[11], pegs[12], pegs[13], pegs[14], pegs[15]))
}

val solved get() = board.count { it } == 1  // just one peg left

fun solve() {
    if (solved) return
    for (peg in 1..15) {
        if (board[peg]) {
            for ((over, land) in jumpMoves[peg]) {
                if (board[over] && !board[land]) {
                    val saveBoard = board.copyOf()
                    board[peg]  = false
                    board[over] = false
                    board[land] = true
                    solutions.add(Solution(peg, over, land))
                    solve()
                    if (solved) return // otherwise back-track
                    board = saveBoard
                    solutions.removeAt(solutions.lastIndex)
                }
            }
        }
    }
}

fun main(args: Array<String>) {
    val emptyStart = 1
    board[emptyStart] = false
    solve()
    board = BooleanArray(16) { if (it == 0) false else true }
    board[emptyStart] = false
    drawBoard()
    println("Starting with peg %X removed\n".format(emptyStart))
    for ((peg, over, land) in solutions) {
        board[peg]  = false
        board[over] = false
        board[land] = true
        drawBoard()
        println("Peg %X jumped over %X to land on %X\n".format(peg, over, land))
    }
}
