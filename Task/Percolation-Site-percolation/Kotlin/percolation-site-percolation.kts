// version 1.2.10

import java.util.Random

val rand = Random()
const val RAND_MAX = 32767
const val NUL = '\u0000'

val x = 15
val y = 15
var grid = StringBuilder((x + 1) * (y + 1) + 1)
var cell = 0
var end = 0
var m = 0
var n = 0

fun makeGrid(p: Double) {
    val thresh = (p * RAND_MAX).toInt()
    m = x
    n = y
    grid.setLength(0)  // clears grid
    grid.setLength(m + 1)  // sets first (m + 1) chars to NUL
    end = m + 1
    cell = m + 1
    for (i in 0 until n) {
        for (j in 0 until m) {
            val r = rand.nextInt(RAND_MAX + 1)
            grid.append(if (r < thresh) '+' else '.')
            end++
        }
        grid.append('\n')
        end++
    }
    grid[end - 1] = NUL
    end -= ++m  // end is the index of the first cell of bottom row
}

fun ff(p: Int): Boolean { // flood fill
    if (grid[p] != '+') return false
    grid[p] = '#'
    return p >= end || ff(p + m) || ff(p + 1) || ff(p - 1) || ff(p - m)
}

fun percolate(): Boolean {
    var i = 0
    while (i < m && !ff(cell + i)) i++
    return i < m
}

fun main(args: Array<String>) {
    makeGrid(0.5)
    percolate()

    println("$x x $y grid:")
    println(grid)

    println("\nrunning 10,000 tests for each case:")
    for (ip in 0..10) {
        val p = ip / 10.0
        var cnt = 0
        for (i in 0 until 10_000) {
            makeGrid(p)
            if (percolate()) cnt++
        }
        println("p = %.1f:  %.4f".format(p, cnt / 10000.0))
    }
}
