// version 1.1.3

val moves = arrayOf(
    intArrayOf(-1, -2), intArrayOf( 1, -2), intArrayOf(-1,  2), intArrayOf(1, 2),
    intArrayOf(-2, -1), intArrayOf(-2,  1), intArrayOf( 2, -1), intArrayOf(2, 1)
)

val board1 =
    " xxx    " +
    " x xx   " +
    " xxxxxxx" +
    "xxx  x x" +
    "x x  xxx" +
    "sxxxxxx " +
    "  xx x  " +
    "   xxx  "

val board2 =
    ".....s.x....." +
    ".....x.x....." +
    "....xxxxx...." +
    ".....xxx....." +
    "..x..x.x..x.." +
    "xxxxx...xxxxx" +
    "..xx.....xx.." +
    "xxxxx...xxxxx" +
    "..x..x.x..x.." +
    ".....xxx....." +
    "....xxxxx...." +
    ".....x.x....." +
    ".....x.x....."

fun solve(pz: Array<IntArray>, sz: Int, sx: Int, sy: Int, idx: Int, cnt: Int): Boolean {
    if (idx > cnt) return true
    for (i in 0 until moves.size) {
        val x = sx + moves[i][0]
        val y = sy + moves[i][1]
        if ((x in 0 until sz) && (y in 0 until sz) && pz[x][y] == 0) {
            pz[x][y] = idx
            if (solve(pz, sz, x, y, idx + 1, cnt)) return true
            pz[x][y] = 0
        }
    }
    return false
}

fun findSolution(b: String, sz: Int) {
    val pz = Array(sz) { IntArray(sz) { -1 } }
    var x = 0
    var y = 0
    var idx = 0
    var cnt = 0
    for (j in 0 until sz) {
        for (i in 0 until sz) {
            if (b[idx] == 'x') {
                pz[i][j] = 0
                cnt++
            }
            else if (b[idx] == 's') {
                pz[i][j] = 1
                cnt++
                x = i
                y = j
            }
            idx++
        }
    }

    if (solve(pz, sz, x, y, 2, cnt)) {
        for (j in 0 until sz) {
            for (i in 0 until sz) {
                if (pz[i][j] != -1)
                    print("%02d  ".format(pz[i][j]))
                else
                    print("--  ")
            }
            println()
        }
    }
    else println("Cannot solve this puzzle!")
}

fun main(args: Array<String>) {
    findSolution(board1,  8)
    println()
    findSolution(board2, 13)
}
