import "random" for Random
import "./iterate" for Reversed

var boxW = 41       // Galton box width.
var boxH = 37       // Galton box height.
var pinsBaseW = 19  // Pins triangle base.
var nMaxBalls = 55  // Number of balls.

var centerH = pinsBaseW + (boxW - pinsBaseW * 2 + 1) / 2 - 1
var Rand = Random.new()

class Cell {
    static EMPTY  { " " }
    static BALL   { "o" }
    static WALL   { "|" }
    static CORNER { "+" }
    static FLOOR  { "-" }
    static PIN    { "." }
}

/* Galton box. Will be printed upside down. */
var Box = List.filled(boxH, null)
for (i in 0...boxH) Box[i] = List.filled(boxW, Cell.EMPTY)

class Ball {
    construct new(x, y) {
        if (Box[x][y] != Cell.EMPTY) Fiber.abort("The cell at (x, y) is not empty.")
        Box[y][x] = Cell.BALL
        _x = x
        _y = y
    }

    doStep() {
        if (_y <= 0) return  // Reached the bottom of the box.
        var cell = Box[_y - 1][_x]
        if (cell == Cell.EMPTY) {
            Box[_y][_x] = Cell.EMPTY
            _y = _y - 1
            Box[_y][_x] = Cell.BALL
        } else if (cell == Cell.PIN) {
            Box[_y][_x] = Cell.EMPTY
            _y = _y - 1
            if (Box[_y][_x - 1] == Cell.EMPTY && Box[_y][_x + 1] == Cell.EMPTY) {
                _x = _x + Rand.int(2) * 2 - 1
                Box[_y][_x] = Cell.BALL
                return
            } else if (Box[_y][_x - 1] == Cell.EMPTY){
                _x = _x + 1
            } else _x = _x - 1
            Box[_y][_x] = Cell.BALL
        } else {
            // It's frozen - it always piles on other balls.
        }
    }
}

var initializeBox = Fn.new {
    // Set ceiling and floor:
    Box[0][0] = Cell.CORNER
    Box[0][boxW - 1] = Cell.CORNER
    for (i in 1...boxW - 1) Box[0][i] = Cell.FLOOR
    for (i in 0...boxW) Box[boxH - 1][i] = Box[0][i]

    // Set walls:
    for (r in 1...boxH - 1) {
        Box[r][0] = Cell.WALL
        Box[r][boxW - 1] = Cell.WALL
    }

    // Set pins:
    for (nPins in 1..pinsBaseW) {
        for (pin in 0...nPins) {
            Box[boxH - 2 - nPins][centerH + 1 - nPins + pin * 2] = Cell.PIN
        }
    }
}

var drawBox = Fn.new() {
    for (row in Reversed.new(Box, 1)) {
        for (c in row) System.write(c)
        System.print()
    }
}

initializeBox.call()
var balls = []
for (i in 0...nMaxBalls + boxH) {
    System.print("\nStep %(i):")
    if (i < nMaxBalls) balls.add(Ball.new(centerH, boxH - 2))  // Add ball.
    drawBox.call()

    // Next step for the simulation.
    // Frozen balls are kept in balls list for simplicity
    for (b in balls) b.doStep()
}
