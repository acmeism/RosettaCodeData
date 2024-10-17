// version 1.2.10

import java.util.Random

val rand = Random()
const val RAND_MAX = 32767

// cell states
const val FILL  = 1
const val RWALL = 2  // right wall
const val BWALL = 4  // bottom wall

val x = 10
val y = 10
var grid = IntArray(x * (y + 2))
var cells = 0
var end = 0
var m = 0
var n = 0

fun makeGrid(p: Double) {
    val thresh = (p * RAND_MAX).toInt()
    m = x
    n = y
    grid.fill(0)  // clears grid
    for (i in 0 until m) grid[i] = BWALL or RWALL
    cells = m
    end = m
    for (i in 0 until y) {
        for (j in x - 1 downTo 1) {
            val r1 = rand.nextInt(RAND_MAX + 1)
            val r2 = rand.nextInt(RAND_MAX + 1)
            grid[end++] = (if (r1 < thresh) BWALL else 0) or
                          (if (r2 < thresh) RWALL else 0)
        }
        val r3 = rand.nextInt(RAND_MAX + 1)
        grid[end++] = RWALL or (if (r3 < thresh) BWALL else 0)
    }
}

fun showGrid() {
    for (j in 0 until m) print("+--")
    println("+")

    for (i in 0..n) {
        print(if (i == n) " " else "|")
        for (j in 0 until m) {
            print(if ((grid[i * m + j + cells] and FILL) != 0) "[]" else "  ")
            print(if ((grid[i * m + j + cells] and RWALL) != 0) "|" else " ")
        }
        println()
        if (i == n) return
        for (j in 0 until m) {
            print(if ((grid[i * m + j + cells] and BWALL) != 0) "+--" else "+  ")
        }
        println("+")
    }
}

fun fill(p: Int): Boolean {
    if ((grid[p] and FILL) != 0) return false
    grid[p] = grid[p] or FILL
    if (p >= end) return true  // success: reached bottom row
    return (((grid[p + 0] and BWALL) == 0) && fill(p + m)) ||
           (((grid[p + 0] and RWALL) == 0) && fill(p + 1)) ||
           (((grid[p - 1] and RWALL) == 0) && fill(p - 1)) ||
           (((grid[p - m] and BWALL) == 0) && fill(p - m))
}

fun percolate(): Boolean {
    var i = 0
    while (i < m && !fill(cells + i)) i++
    return i < m
}

fun main(args: Array<String>) {
    makeGrid(0.5)
    percolate()
    showGrid()

    println("\nrunning $x x $y grids 10,000 times for each p:")
    for (p in 1..9) {
        var cnt = 0
        val pp = p / 10.0
        for (i in 0 until 10_000) {
            makeGrid(pp)
            if (percolate()) cnt++
        }
        println("p = %3g: %.4f".format(pp, cnt.toDouble() / 10_000))
    }
}
