// version 1.2.0

import java.util.Random
import java.io.File

val dirs = listOf(
    intArrayOf( 1, 0), intArrayOf(0,  1), intArrayOf( 1,  1), intArrayOf( 1, -1),
    intArrayOf(-1, 0), intArrayOf(0, -1), intArrayOf(-1, -1), intArrayOf(-1,  1)
)

val nRows = 10
val nCols = 10
val gridSize = nRows * nCols
val minWords = 25
val rand = Random()

class Grid {
    var numAttempts = 0
    val cells = List(nRows) { CharArray(nCols) }
    val solutions = mutableListOf<String>()
}

fun readWords(fileName: String): List<String> {
    val maxLen = maxOf(nRows, nCols)
    val rx = Regex("^[a-z]{3,$maxLen}$")
    val f = File(fileName)
    return f.readLines().map { it.trim().toLowerCase() }
                        .filter { it.matches(rx) }
}

fun createWordSearch(words: List<String>): Grid {
    var numAttempts = 0
    lateinit var grid: Grid
    outer@ while (++numAttempts < 100) {
        grid = Grid()
        val messageLen = placeMessage(grid, "Rosetta Code")
        val target = gridSize - messageLen
        var cellsFilled = 0
        for (word in words.shuffled()) {
            cellsFilled += tryPlaceWord(grid, word)
            if (cellsFilled == target) {
                if (grid.solutions.size >= minWords) {
                    grid.numAttempts = numAttempts
                    break@outer
                }
                else { // grid is full but we didn't pack enough words, start over
                    break
                }
            }
        }
    }
    return grid
}

fun placeMessage(grid: Grid, msg: String): Int {
    val rx = Regex("[^A-Z]")
    val msg2 = msg.toUpperCase().replace(rx, "")
    val messageLen = msg2.length
    if (messageLen in (1 until gridSize)) {
        val gapSize = gridSize / messageLen
        for (i in 0 until messageLen) {
            val pos = i * gapSize + rand.nextInt(gapSize)
            grid.cells[pos / nCols][pos % nCols] = msg2[i]
        }
        return messageLen
    }
    return 0
}

fun tryPlaceWord(grid: Grid, word: String): Int {
    val randDir = rand.nextInt(dirs.size)
    val randPos = rand.nextInt(gridSize)
    for (d in 0 until dirs.size) {
        val dir = (d + randDir) % dirs.size
        for (p in 0 until gridSize) {
            val pos = (p + randPos) % gridSize
            val lettersPlaced = tryLocation(grid, word, dir, pos)
            if (lettersPlaced > 0) return lettersPlaced
        }
    }
    return 0
}

fun tryLocation(grid: Grid, word: String, dir: Int, pos: Int): Int {
    val r = pos / nCols
    val c = pos % nCols
    val len = word.length

    // check bounds
    if ((dirs[dir][0] == 1 && (len + c) > nCols)
        || (dirs[dir][0] == -1 && (len - 1) > c)
        || (dirs[dir][1] ==  1 && (len + r) > nRows)
        || (dirs[dir][1] == -1 && (len - 1) > r)) return 0
    var overlaps = 0

    // check cells
    var rr = r
    var cc = c
    for (i in 0 until len) {
        if (grid.cells[rr][cc] != '\u0000' && grid.cells[rr][cc] != word[i]) return 0
        cc += dirs[dir][0]
        rr += dirs[dir][1]
    }

    // place
    rr = r
    cc = c
    for (i in 0 until len) {
        if (grid.cells[rr][cc] == word[i])
            overlaps++
        else
            grid.cells[rr][cc] = word[i]

        if (i < len - 1) {
            cc += dirs[dir][0]
            rr += dirs[dir][1]
        }
    }

    val lettersPlaced = len - overlaps
    if (lettersPlaced > 0) {
        grid.solutions.add(String.format("%-10s (%d,%d)(%d,%d)", word, c, r, cc, rr))
    }
    return lettersPlaced
}

fun printResult(grid: Grid) {
    if (grid.numAttempts == 0) {
        println("No grid to display")
        return
    }
    val size = grid.solutions.size
    println("Attempts: ${grid.numAttempts}")
    println("Number of words: $size")
    println("\n     0  1  2  3  4  5  6  7  8  9")
    for (r in 0 until nRows) {
         print("\n$r   ")
         for (c in 0 until nCols) print(" ${grid.cells[r][c]} ")
    }

    println("\n")

    for (i in 0 until size - 1 step 2) {
        println("${grid.solutions[i]}   ${grid.solutions[i + 1]}")
    }
    if (size % 2 == 1) println(grid.solutions[size - 1])
}

fun main(args: Array<String>) {
    printResult(createWordSearch(readWords("unixdict.txt")))
}
