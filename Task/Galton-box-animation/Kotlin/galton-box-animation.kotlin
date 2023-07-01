// version 1.2.10

import java.util.Random

val boxW = 41       // Galton box width.
val boxH = 37       // Galton box height.
val pinsBaseW = 19  // Pins triangle base.
val nMaxBalls = 55  // Number of balls.

val centerH = pinsBaseW + (boxW - pinsBaseW * 2 + 1) / 2 - 1
val rand = Random()

enum class Cell(val c: Char) {
    EMPTY(' '),
    BALL('o'),
    WALL('|'),
    CORNER('+'),
    FLOOR('-'),
    PIN('.')
}

/* Galton box. Will be printed upside down. */
val box = List(boxH) { Array<Cell>(boxW) { Cell.EMPTY } }

class Ball(var x: Int, var y: Int) {

    init {
        require(box[y][x] == Cell.EMPTY)
        box[y][x] = Cell.BALL
    }

    fun doStep() {
        if (y <= 0) return  // Reached the bottom of the box.
        val cell = box[y - 1][x]
        when (cell) {
            Cell.EMPTY -> {
                box[y][x] = Cell.EMPTY
                y--
                box[y][x] = Cell.BALL
            }

            Cell.PIN -> {
                box[y][x] = Cell.EMPTY
                y--
                if (box[y][x - 1] == Cell.EMPTY && box[y][x + 1] == Cell.EMPTY) {
                    x += rand.nextInt(2) * 2 - 1
                    box[y][x] = Cell.BALL
                    return
                }
                else if (box[y][x - 1] == Cell.EMPTY) x++
                else x--
                box[y][x] = Cell.BALL
            }

            else -> {
                // It's frozen - it always piles on other balls.
            }
        }
    }
}

fun initializeBox() {
    // Set ceiling and floor:
    box[0][0] = Cell.CORNER
    box[0][boxW - 1] = Cell.CORNER
    for (i in 1 until boxW - 1) box[0][i] = Cell.FLOOR
    for (i in 0 until boxW) box[boxH - 1][i] = box[0][i]

    // Set walls:
    for (r in 1 until boxH - 1) {
        box[r][0] = Cell.WALL
        box[r][boxW - 1] = Cell.WALL
    }

    // Set pins:
    for (nPins in 1..pinsBaseW) {
        for (pin in 0 until nPins) {
            box[boxH - 2 - nPins][centerH + 1 - nPins + pin * 2] = Cell.PIN
        }
    }
}

fun drawBox() {
    for (row in box.reversed()) {
        for (i in row.indices) print(row[i].c)
        println()
    }
}

fun main(args: Array<String>) {
    initializeBox()
    val balls = mutableListOf<Ball>()
    for (i in 0 until nMaxBalls + boxH) {
        println("\nStep $i:")
        if (i < nMaxBalls) balls.add(Ball(centerH, boxH - 2))  // Add ball.
        drawBox()

        // Next step for the simulation.
        // Frozen balls are kept in balls list for simplicity
        for (b in balls) b.doStep()
    }
}
