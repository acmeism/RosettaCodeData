// Version 1.1.4-3

import java.util.Random

val F = arrayOf(
    intArrayOf(1, -1, 1, 0, 1, 1, 2, 1), intArrayOf(0, 1, 1, -1, 1, 0, 2, 0),
    intArrayOf(1, 0, 1, 1, 1, 2, 2, 1), intArrayOf(1, 0, 1, 1, 2, -1, 2, 0),
    intArrayOf(1, -2, 1, -1, 1, 0, 2, -1), intArrayOf(0, 1, 1, 1, 1, 2, 2, 1),
    intArrayOf(1, -1, 1, 0, 1, 1, 2, -1), intArrayOf(1, -1, 1, 0, 2, 0, 2, 1)
)

val I = arrayOf(
    intArrayOf(0, 1, 0, 2, 0, 3, 0, 4), intArrayOf(1, 0, 2, 0, 3, 0, 4, 0)
)

val L = arrayOf(
    intArrayOf(1, 0, 1, 1, 1, 2, 1, 3), intArrayOf(1, 0, 2, 0, 3, -1, 3, 0),
    intArrayOf(0, 1, 0, 2, 0, 3, 1, 3), intArrayOf(0, 1, 1, 0, 2, 0, 3, 0),
    intArrayOf(0, 1, 1, 1, 2, 1, 3, 1), intArrayOf(0, 1, 0, 2, 0, 3, 1, 0),
    intArrayOf(1, 0, 2, 0, 3, 0, 3, 1), intArrayOf(1, -3, 1, -2, 1, -1, 1, 0)
)

val N = arrayOf(
    intArrayOf(0, 1, 1, -2, 1, -1, 1, 0), intArrayOf(1, 0, 1, 1, 2, 1, 3, 1),
    intArrayOf(0, 1, 0, 2, 1, -1, 1, 0), intArrayOf(1, 0, 2, 0, 2, 1, 3, 1),
    intArrayOf(0, 1, 1, 1, 1, 2, 1, 3), intArrayOf(1, 0, 2, -1, 2, 0, 3, -1),
    intArrayOf(0, 1, 0, 2, 1, 2, 1, 3), intArrayOf(1, -1, 1, 0, 2, -1, 3, -1)
)

val P = arrayOf(
    intArrayOf(0, 1, 1, 0, 1, 1, 2, 1), intArrayOf(0, 1, 0, 2, 1, 0, 1, 1),
    intArrayOf(1, 0, 1, 1, 2, 0, 2, 1), intArrayOf(0, 1, 1, -1, 1, 0, 1, 1),
    intArrayOf(0, 1, 1, 0, 1, 1, 1, 2), intArrayOf(1, -1, 1, 0, 2, -1, 2, 0),
    intArrayOf(0, 1, 0, 2, 1, 1, 1, 2), intArrayOf(0, 1, 1, 0, 1, 1, 2, 0)
)

val T = arrayOf(
    intArrayOf(0, 1, 0, 2, 1, 1, 2, 1), intArrayOf(1, -2, 1, -1, 1, 0, 2, 0),
    intArrayOf(1, 0, 2, -1, 2, 0, 2, 1), intArrayOf(1, 0, 1, 1, 1, 2, 2, 0)
)

val U = arrayOf(
    intArrayOf(0, 1, 0, 2, 1, 0, 1, 2), intArrayOf(0, 1, 1, 1, 2, 0, 2, 1),
    intArrayOf(0, 2, 1, 0, 1, 1, 1, 2), intArrayOf(0, 1, 1, 0, 2, 0, 2, 1)
)

val V = arrayOf(
    intArrayOf(1, 0, 2, 0, 2, 1, 2, 2), intArrayOf(0, 1, 0, 2, 1, 0, 2, 0),
    intArrayOf(1, 0, 2, -2, 2, -1, 2, 0), intArrayOf(0, 1, 0, 2, 1, 2, 2, 2)
)

val W = arrayOf(
    intArrayOf(1, 0, 1, 1, 2, 1, 2, 2), intArrayOf(1, -1, 1, 0, 2, -2, 2, -1),
    intArrayOf(0, 1, 1, 1, 1, 2, 2, 2), intArrayOf(0, 1, 1, -1, 1, 0, 2, -1)
)

val X = arrayOf(intArrayOf(1, -1, 1, 0, 1, 1, 2, 0))

val Y = arrayOf(
    intArrayOf(1, -2, 1, -1, 1, 0, 1, 1), intArrayOf(1, -1, 1, 0, 2, 0, 3, 0),
    intArrayOf(0, 1, 0, 2, 0, 3, 1, 1), intArrayOf(1, 0, 2, 0, 2, 1, 3, 0),
    intArrayOf(0, 1, 0, 2, 0, 3, 1, 2), intArrayOf(1, 0, 1, 1, 2, 0, 3, 0),
    intArrayOf(1, -1, 1, 0, 1, 1, 1, 2), intArrayOf(1, 0, 2, -1, 2, 0, 3, 0)
)

val Z = arrayOf(
    intArrayOf(0, 1, 1, 0, 2, -1, 2, 0), intArrayOf(1, 0, 1, 1, 1, 2, 2, 2),
    intArrayOf(0, 1, 1, 1, 2, 1, 2, 2), intArrayOf(1, -2, 1, -1, 1, 0, 2, -2)
)

val shapes = arrayOf(F, I, L, N, P, T, U, V, W, X, Y, Z)
val rand = Random()

val symbols = "FILNPTUVWXYZ-".toCharArray()

val nRows = 8
val nCols = 8
val blank = 12

val grid = Array(nRows) { IntArray(nCols) }
val placed = BooleanArray(symbols.size - 1)

fun tryPlaceOrientation(o: IntArray, r: Int, c: Int, shapeIndex: Int): Boolean {
    for (i in 0 until o.size step 2) {
        val x = c + o[i + 1]
        val y = r + o[i]
        if (x !in (0 until nCols) || y !in (0 until nRows) || grid[y][x] != - 1) return false
    }
    grid[r][c] = shapeIndex
    for (i in 0 until o.size step 2) grid[r + o[i]][c + o[i + 1]] = shapeIndex
    return true
}

fun removeOrientation(o: IntArray, r: Int, c: Int) {
    grid[r][c] = -1
    for (i in 0 until o.size step 2) grid[r + o[i]][c + o[i + 1]] = -1
}

fun solve(pos: Int, numPlaced: Int): Boolean {
    if (numPlaced == shapes.size) return true
    val row = pos / nCols
    val col = pos % nCols
    if (grid[row][col] != -1) return solve(pos + 1, numPlaced)

    for (i in 0 until shapes.size) {
        if (!placed[i]) {
            for (orientation in shapes[i]) {
                if (!tryPlaceOrientation(orientation, row, col, i)) continue
                placed[i] = true
                if (solve(pos + 1, numPlaced + 1)) return true
                removeOrientation(orientation, row, col)
                placed[i] = false
            }
        }
    }
    return false
}

fun shuffleShapes() {
    var n = shapes.size
    while (n > 1) {
        val r = rand.nextInt(n--)
        val tmp = shapes[r]
        shapes[r] = shapes[n]
        shapes[n] = tmp
        val tmpSymbol= symbols[r]
        symbols[r] = symbols[n]
        symbols[n] = tmpSymbol
    }
}

fun printResult() {
    for (r in grid) {
        for (i in r) print("${symbols[i]} ")
        println()
    }
}

fun main(args: Array<String>) {
    shuffleShapes()
    for (r in 0 until nRows) grid[r].fill(-1)
    for (i in 0..3) {
        var randRow: Int
        var randCol: Int
        do {
            randRow = rand.nextInt(nRows)
            randCol = rand.nextInt(nCols)
        }
        while (grid[randRow][randCol] == blank)
        grid[randRow][randCol] = blank
    }
    if (solve(0, 0)) printResult()
    else println("No solution")
}
