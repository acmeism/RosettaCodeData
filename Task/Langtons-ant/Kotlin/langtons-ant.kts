// version 1.2.0

enum class Direction { UP, RIGHT, DOWN, LEFT }

const val WHITE = 0
const val BLACK = 1

fun main(args: Array<String>) {
    val width = 75
    val height = 52
    val maxSteps = 12_000
    var x = width / 2
    var y = height / 2
    val m = Array(height) { IntArray(width) }
    var dir = Direction.UP
    var i = 0
    while (i < maxSteps && x in 0 until width && y in 0 until height) {
        val turn = m[y][x] == BLACK
        val index = (dir.ordinal + if (turn) 1 else -1) and 3
        dir = Direction.values()[index]
        m[y][x] = if (m[y][x] == BLACK) WHITE else BLACK
        when (dir) {
             Direction.UP    -> y--
             Direction.RIGHT -> x--
             Direction.DOWN  -> y++
             Direction.LEFT  -> x++
        }
        i++
    }
    for (j in 0 until height) {
        for (k in 0 until width) print(if(m[j][k] == WHITE) '.' else '#')
        println()
    }
}
