// version 1.2.10

class Sudoku(rows: List<String>) {
    private val grid = IntArray(81)
    private var solved = false

    init {
        require(rows.size == 9 && rows.all { it.length == 9 }) {
            "Grid must be 9 x 9"
        }
        for (i in 0..8) {
            for (j in 0..8 ) grid[9 * i + j] = rows[i][j] - '0'
        }
    }

    fun solve() {
        println("Starting grid:\n\n$this")
        placeNumber(0)
        println(if (solved) "Solution:\n\n$this" else "Unsolvable!")
    }

    private fun placeNumber(pos: Int) {
        if (solved) return
        if (pos == 81) {
            solved = true
            return
        }
        if (grid[pos] > 0) {
            placeNumber(pos + 1)
            return
        }
        for (n in 1..9) {
            if (checkValidity(n, pos % 9, pos / 9)) {
                grid[pos] = n
                placeNumber(pos + 1)
                if (solved) return
                grid[pos] = 0
            }
        }
    }

    private fun checkValidity(v: Int, x: Int, y: Int): Boolean {
        for (i in 0..8) {
            if (grid[y * 9 + i] == v || grid[i * 9 + x] == v) return false
        }
        val startX = (x / 3) * 3
        val startY = (y / 3) * 3
        for (i in startY until startY + 3) {
            for (j in startX until startX + 3) {
                if (grid[i * 9 + j] == v) return false
            }
        }
        return true
    }

    override fun toString(): String {
        val sb = StringBuilder()
        for (i in 0..8) {
            for (j in 0..8) {
                sb.append(grid[i * 9 + j])
                sb.append(" ")
                if (j == 2 || j == 5) sb.append("| ")
            }
            sb.append("\n")
            if (i == 2 || i == 5) sb.append("------+-------+------\n")
        }
        return sb.toString()
    }
}

fun main(args: Array<String>) {
    val rows = listOf(
        "850002400",
        "720000009",
        "004000000",
        "000107002",
        "305000900",
        "040000000",
        "000080070",
        "017000000",
        "000036040"
    )
    Sudoku(rows).solve()
}
