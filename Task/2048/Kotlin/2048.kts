import java.io.BufferedReader
import java.io.InputStreamReader

const val positiveGameOverMessage = "So sorry, but you won the game."
const val negativeGameOverMessage = "So sorry, but you lost the game."

fun main(args: Array<String>) {
    val grid = arrayOf(
            arrayOf(0, 0, 0, 0),
            arrayOf(0, 0, 0, 0),
            arrayOf(0, 0, 0, 0),
            arrayOf(0, 0, 0, 0)
    )

    val gameOverMessage = run2048(grid)
    println(gameOverMessage)
}

fun run2048(grid: Array<Array<Int>>): String {
    if (isGridSolved(grid)) return positiveGameOverMessage
    else if (isGridFull(grid)) return negativeGameOverMessage

    val populatedGrid = spawnNumber(grid)
    display(populatedGrid)

    return run2048(manipulateGrid(populatedGrid, waitForValidInput()))
}

fun isGridSolved(grid: Array<Array<Int>>): Boolean = grid.any { row -> row.contains(2048) }
fun isGridFull(grid: Array<Array<Int>>): Boolean = grid.all { row -> !row.contains(0) }

fun spawnNumber(grid: Array<Array<Int>>): Array<Array<Int>> {
    val coordinates = locateSpawnCoordinates(grid)
    val number = generateNumber()

    return updateGrid(grid, coordinates, number)
}

fun locateSpawnCoordinates(grid: Array<Array<Int>>): Pair<Int, Int> {
    val emptyCells = arrayListOf<Pair<Int, Int>>()
    grid.forEachIndexed { x, row ->
        row.forEachIndexed { y, cell ->
            if (cell == 0) emptyCells.add(Pair(x, y))
        }
    }

    return emptyCells[(Math.random() * (emptyCells.size - 1)).toInt()]
}

fun generateNumber(): Int = if (Math.random() > 0.10) 2 else 4

fun updateGrid(grid: Array<Array<Int>>, at: Pair<Int, Int>, value: Int): Array<Array<Int>> {
    val updatedGrid = grid.copyOf()
    updatedGrid[at.first][at.second] = value
    return updatedGrid
}

fun waitForValidInput(): String {
    val input = waitForInput()
    return if (isValidInput(input)) input else waitForValidInput()
}

fun isValidInput(input: String): Boolean = arrayOf("a", "s", "d", "w").contains(input)

fun waitForInput(): String {
    val reader = BufferedReader(InputStreamReader(System.`in`))
    println("Direction?  ")
    return reader.readLine()
}

fun manipulateGrid(grid: Array<Array<Int>>, input: String): Array<Array<Int>> = when (input) {
    "a" -> shiftCellsLeft(grid)
    "s" -> shiftCellsDown(grid)
    "d" -> shiftCellsRight(grid)
    "w" -> shiftCellsUp(grid)
    else -> throw IllegalArgumentException("Expected one of [a, s, d, w]")
}

fun shiftCellsLeft(grid: Array<Array<Int>>): Array<Array<Int>> =
        grid.map(::mergeAndOrganizeCells).toTypedArray()

fun shiftCellsRight(grid: Array<Array<Int>>): Array<Array<Int>> =
        grid.map { row -> mergeAndOrganizeCells(row.reversed().toTypedArray()).reversed().toTypedArray() }.toTypedArray()

fun shiftCellsUp(grid: Array<Array<Int>>): Array<Array<Int>> {
    val rows: Array<Array<Int>> = arrayOf(
            arrayOf(grid[0][0], grid[1][0], grid[2][0], grid[3][0]),
            arrayOf(grid[0][1], grid[1][1], grid[2][1], grid[3][1]),
            arrayOf(grid[0][2], grid[1][2], grid[2][2], grid[3][2]),
            arrayOf(grid[0][3], grid[1][3], grid[2][3], grid[3][3])
    )

    val updatedGrid = grid.copyOf()

    rows.map(::mergeAndOrganizeCells).forEachIndexed { rowIdx, row ->
        updatedGrid[0][rowIdx] = row[0]
        updatedGrid[1][rowIdx] = row[1]
        updatedGrid[2][rowIdx] = row[2]
        updatedGrid[3][rowIdx] = row[3]
    }

    return updatedGrid
}

fun shiftCellsDown(grid: Array<Array<Int>>): Array<Array<Int>> {
    val rows: Array<Array<Int>> = arrayOf(
            arrayOf(grid[3][0], grid[2][0], grid[1][0], grid[0][0]),
            arrayOf(grid[3][1], grid[2][1], grid[1][1], grid[0][1]),
            arrayOf(grid[3][2], grid[2][2], grid[1][2], grid[0][2]),
            arrayOf(grid[3][3], grid[2][3], grid[1][3], grid[0][3])
    )

    val updatedGrid = grid.copyOf()

    rows.map(::mergeAndOrganizeCells).forEachIndexed { rowIdx, row ->
        updatedGrid[3][rowIdx] = row[0]
        updatedGrid[2][rowIdx] = row[1]
        updatedGrid[1][rowIdx] = row[2]
        updatedGrid[0][rowIdx] = row[3]
    }

    return updatedGrid
}

fun mergeAndOrganizeCells(row: Array<Int>): Array<Int> = organize(merge(row.copyOf()))

fun merge(row: Array<Int>, idxToMatch: Int = 0, idxToCompare: Int = 1): Array<Int> {
    if (idxToMatch >= row.size) return row
    if (idxToCompare >= row.size) return merge(row, idxToMatch + 1, idxToMatch + 2)
    if (row[idxToMatch] == 0) return merge(row, idxToMatch + 1, idxToMatch + 2)

    return if (row[idxToMatch] == row[idxToCompare]) {
        row[idxToMatch] *= 2
        row[idxToCompare] = 0
        merge(row, idxToMatch + 1, idxToMatch + 2)
    } else {
        if (row[idxToCompare] != 0) merge(row, idxToMatch + 1, idxToMatch + 2)
        else merge(row, idxToMatch, idxToCompare + 1)
    }
}

fun organize(row: Array<Int>, idxToMatch: Int = 0, idxToCompare: Int = 1): Array<Int> {
    if (idxToMatch >= row.size) return row
    if (idxToCompare >= row.size) return organize(row, idxToMatch + 1, idxToMatch + 2)
    if (row[idxToMatch] != 0) return organize(row, idxToMatch + 1, idxToMatch + 2)

    return if (row[idxToCompare] != 0) {
        row[idxToMatch] = row[idxToCompare]
        row[idxToCompare] = 0
        organize(row, idxToMatch + 1, idxToMatch + 2)
    } else {
        organize(row, idxToMatch, idxToCompare + 1)
    }
}

fun display(grid: Array<Array<Int>>) {
    val prettyPrintableGrid = grid.map { row ->
        row.map { cell ->
            if (cell == 0) "    " else java.lang.String.format("%4d", cell)
        }
    }

    println("New Grid:")
    prettyPrintableGrid.forEach { row ->
        println("+----+----+----+----+")
        row.forEach { print("|$it") }
        println("|")
    }
    println("+----+----+----+----+")
}
