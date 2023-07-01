import "random" for Random
import "/iterate" for Stepped

var F = [
    [1, -1, 1,  0, 1, 1, 2,  1], [0,  1, 1, -1, 1,  0, 2, 0],
    [1,  0, 1,  1, 1, 2, 2,  1], [1,  0, 1,  1, 2, -1, 2, 0],
    [1, -2, 1, -1, 1, 0, 2, -1], [0,  1, 1,  1, 1,  2, 2, 1],
    [1, -1, 1,  0, 1, 1, 2, -1], [1, -1, 1,  0, 2,  0, 2, 1]
]

var I = [
    [0, 1, 0, 2, 0, 3, 0, 4], [1, 0, 2, 0, 3, 0, 4, 0]
]

var L = [
    [1, 0, 1, 1, 1, 2, 1, 3], [1,  0, 2,  0, 3, -1, 3, 0],
    [0, 1, 0, 2, 0, 3, 1, 3], [0,  1, 1,  0, 2,  0, 3, 0],
    [0, 1, 1, 1, 2, 1, 3, 1], [0,  1, 0,  2, 0,  3, 1, 0],
    [1, 0, 2, 0, 3, 0, 3, 1], [1, -3, 1, -2, 1, -1, 1, 0]
]

var N = [
    [0, 1, 1, -2, 1, -1, 1, 0], [1,  0, 1,  1, 2,  1, 3,  1],
    [0, 1, 0,  2, 1, -1, 1, 0], [1,  0, 2,  0, 2,  1, 3,  1],
    [0, 1, 1,  1, 1,  2, 1, 3], [1,  0, 2, -1, 2,  0, 3, -1],
    [0, 1, 0,  2, 1,  2, 1, 3], [1, -1, 1,  0, 2, -1, 3, -1]
]

var P = [
    [0, 1, 1, 0, 1, 1, 2, 1], [0,  1, 0,  2, 1,  0, 1, 1],
    [1, 0, 1, 1, 2, 0, 2, 1], [0,  1, 1, -1, 1,  0, 1, 1],
    [0, 1, 1, 0, 1, 1, 1, 2], [1, -1, 1,  0, 2, -1, 2, 0],
    [0, 1, 0, 2, 1, 1, 1, 2], [0,  1, 1,  0, 1,  1, 2, 0]
]

var T = [
    [0, 1, 0,  2, 1, 1, 2, 1], [1, -2, 1, -1, 1, 0, 2, 0],
    [1, 0, 2, -1, 2, 0, 2, 1], [1,  0, 1,  1, 1, 2, 2, 0]
]

var U = [
    [0, 1, 0, 2, 1, 0, 1, 2], [0, 1, 1, 1, 2, 0, 2, 1],
    [0, 2, 1, 0, 1, 1, 1, 2], [0, 1, 1, 0, 2, 0, 2, 1]
]

var V = [
    [1, 0, 2,  0, 2,  1, 2, 2], [0, 1, 0, 2, 1, 0, 2, 0],
    [1, 0, 2, -2, 2, -1, 2, 0], [0, 1, 0, 2, 1, 2, 2, 2]
]

var W = [
    [1, 0, 1, 1, 2, 1, 2, 2], [1, -1, 1,  0, 2, -2, 2, -1],
    [0, 1, 1, 1, 1, 2, 2, 2], [0,  1, 1, -1, 1,  0, 2, -1]
]

var X = [[1, -1, 1, 0, 1, 1, 2, 0]]

var Y = [
    [1, -2, 1, -1, 1, 0, 1, 1], [1, -1, 1,  0, 2, 0, 3, 0],
    [0,  1, 0,  2, 0, 3, 1, 1], [1,  0, 2,  0, 2, 1, 3, 0],
    [0,  1, 0,  2, 0, 3, 1, 2], [1,  0, 1,  1, 2, 0, 3, 0],
    [1, -1, 1,  0, 1, 1, 1, 2], [1,  0, 2, -1, 2, 0, 3, 0]
]

var Z = [
    [0, 1, 1, 0, 2, -1, 2, 0], [1,  0, 1,  1, 1, 2, 2,  2],
    [0, 1, 1, 1, 2,  1, 2, 2], [1, -2, 1, -1, 1, 0, 2, -2]
]

var shapes = [F, I, L, N, P, T, U, V, W, X, Y, Z]
var rand = Random.new()

var symbols = "FILNPTUVWXYZ-".toList

var nRows = 8
var nCols = 8
var blank = 12

var grid = List.filled(nRows, null)
for (i in 0...nRows) grid[i] = List.filled(nCols, 0)

var placed = List.filled(symbols.count - 1, false)

var tryPlaceOrientation = Fn.new { |o, r, c, shapeIndex|
    for (i in Stepped.new(0...o.count, 2)) {
        var x = c + o[i + 1]
        var y = r + o[i]
        if (x < 0 || x >= nCols || y < 0 || y >= nRows || grid[y][x] != - 1) return false
    }
    grid[r][c] = shapeIndex
    for (i in Stepped.new(0...o.count, 2)) grid[r + o[i]][c + o[i + 1]] = shapeIndex
    return true
}

var removeOrientation = Fn.new { |o, r, c|
    grid[r][c] = -1
    for (i in Stepped.new(0...o.count, 2)) grid[r + o[i]][c + o[i + 1]] = -1
}

var solve  // recursive
solve = Fn.new { |pos, numPlaced|
    if (numPlaced == shapes.count) return true
    var row = (pos / nCols).floor
    var col = pos % nCols
    if (grid[row][col] != -1) return solve.call(pos + 1, numPlaced)

    for (i in 0...shapes.count) {
        if (!placed[i]) {
            for (orientation in shapes[i]) {
                if (!tryPlaceOrientation.call(orientation, row, col, i)) continue
                placed[i] = true
                if (solve.call(pos + 1, numPlaced + 1)) return true
                removeOrientation.call(orientation, row, col)
                placed[i] = false
            }
        }
    }
    return false
}

var shuffleShapes = Fn.new {
    var n = shapes.count
    while (n > 1) {
        var r = rand.int(n)
        n = n - 1
        shapes.swap(r, n)
        symbols.swap(r, n)
    }
}

var printResult = Fn.new {
    for (r in grid) {
        for (i in r) System.write("%(symbols[i]) ")
        System.print()
    }
}

shuffleShapes.call()
for (r in 0...nRows) {
    for (c in 0...grid[r].count) grid[r][c] = -1
}
for (i in 0..3) {
    var randRow
    var randCol
    while (true) {
        randRow = rand.int(nRows)
        randCol = rand.int(nCols)
        if (grid[randRow][randCol] != blank) break
    }
    grid[randRow][randCol] = blank
}
if (solve.call(0, 0)) printResult.call() else System.print("No solution")
