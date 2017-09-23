data class Square(val x : Int, val y : Int)

val board = Array(8 * 8, { Square(it / 8 + 1, it % 8 + 1) })
val axisMoves = arrayOf(1, 2, -1, -2)

fun <T> allPairs(a: Array<T>) = a.flatMap { i -> a.map { j -> Pair(i, j) } }

fun knightMoves(s : Square) : List<Square> {
    val moves = allPairs(axisMoves).filter{ Math.abs(it.first) != Math.abs(it.second) }
    fun onBoard(s : Square) = board.any {it == s}
    return moves.map { Square(s.x + it.first, s.y + it.second) }.filter(::onBoard)
}

fun knightTour(moves : List<Square>) : List<Square> {
    fun findMoves(s: Square) = knightMoves(s).filterNot { m -> moves.any { it == m } }
    val newSquare = findMoves(moves.last()).minBy { findMoves(it).size }
    return if (newSquare == null) moves else knightTour(moves + newSquare)
}

fun knightTourFrom(start : Square) = knightTour(listOf(start))

fun main(args : Array<String>) {
    var col = 0
    for ((x, y) in knightTourFrom(Square(1, 1))) {
        System.out.print("$x,$y")
        System.out.print(if (col == 7) "\n" else " ")
        col = (col + 1) % 8
    }
}
