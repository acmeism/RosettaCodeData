import java.util.*

class MazeGenerator(val x: Int, val y: Int) {
    private val maze = Array(x) { IntArray(y) }

    fun generate(cx: Int, cy: Int) {
        Direction.values().shuffle().forEach {
            val nx = cx + it.dx
            val ny = cy + it.dy
            if (between(nx, x) && between(ny, y) && maze[nx][ny] == 0) {
                maze[cx][cy] = maze[cx][cy] or it.bit
                maze[nx][ny] = maze[nx][ny] or it.opposite!!.bit
                generate(nx, ny)
            }
        }
    }

    fun display() {
        for (i in 0..y - 1) {
            // draw the north edge
            for (j in 0..x - 1)
                print(if (maze[j][i] and 1 == 0) "+---" else "+   ")
            println('+')

            // draw the west edge
            for (j in 0..x - 1)
                print(if (maze[j][i] and 8 == 0) "|   " else "    ")
            println('|')
        }

        // draw the bottom line
        for (j in 0..x - 1) print("+---")
        println('+')
    }

    inline private fun <reified T> Array<T>.shuffle(): Array<T> {
        val list = toMutableList()
        Collections.shuffle(list)
        return list.toTypedArray()
    }

    private enum class Direction(val bit: Int, val dx: Int, val dy: Int) {
        N(1, 0, -1), S(2, 0, 1), E(4, 1, 0),W(8, -1, 0);

        var opposite: Direction? = null

        companion object {
            init {
                N.opposite = S
                S.opposite = N
                E.opposite = W
                W.opposite = E
            }
        }
    }

    private fun between(v: Int, upper: Int) = v >= 0 && v < upper
}

fun main(args: Array<String>) {
    val x = if (args.size >= 1) args[0].toInt() else 8
    val y = if (args.size == 2) args[1].toInt() else 8
    with(MazeGenerator(x, y)) {
        generate(0, 0)
        display()
    }
}
