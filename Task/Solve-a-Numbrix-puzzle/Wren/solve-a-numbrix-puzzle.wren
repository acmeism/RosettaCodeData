import "/sort" for Sort
import "/fmt" for Fmt

var example1 = [
    "00,00,00,00,00,00,00,00,00",
    "00,00,46,45,00,55,74,00,00",
    "00,38,00,00,43,00,00,78,00",
    "00,35,00,00,00,00,00,71,00",
    "00,00,33,00,00,00,59,00,00",
    "00,17,00,00,00,00,00,67,00",
    "00,18,00,00,11,00,00,64,00",
    "00,00,24,21,00,01,02,00,00",
    "00,00,00,00,00,00,00,00,00"
]

var example2 = [
    "00,00,00,00,00,00,00,00,00",
    "00,11,12,15,18,21,62,61,00",
    "00,06,00,00,00,00,00,60,00",
    "00,33,00,00,00,00,00,57,00",
    "00,32,00,00,00,00,00,56,00",
    "00,37,00,01,00,00,00,73,00",
    "00,38,00,00,00,00,00,72,00",
    "00,43,44,47,48,51,76,77,00",
    "00,00,00,00,00,00,00,00,00"
]

var moves = [ [1, 0], [0, 1], [-1, 0], [0, -1] ]

var board = []
var grid  = []
var clues = []
var totalToFill = 0

var solve // recursive
solve = Fn.new { |r, c, count, nextClue|
    if (count > totalToFill) return true
    var back = grid[r][c]
    if (back != 0 && back != count) return false
    if (back == 0 && nextClue < clues.count && clues[nextClue] == count) {
        return false
    }
    if (back == count) nextClue = nextClue + 1
    grid[r][c] = count
    for (m in moves) {
        if (solve.call(r + m[1], c + m[0], count + 1, nextClue)) return true
    }
    grid[r][c] = back
    return false
}

var printResult = Fn.new { |n|
    System.print("Solution for example %(n):")
    for (row in grid) {
        for (i in row) if (i != -1) Fmt.write("$2d ", i)
        System.print()
    }
}

var n = 0
for (ex in [example1, example2]) {
    board = ex
    var nRows = board.count + 2
    var nCols = board[0].split(",").count + 2
    var startRow = 0
    var startCol = 0
    grid = List.filled(nRows, null)
    for (i in 0...nRows) grid[i] = List.filled(nCols, -1)
    totalToFill = (nRows - 2) * (nCols - 2)
    var lst = []
    for (r in 0...nRows) {
        if (r >= 1 && r < nRows - 1) {
            var row = board[r - 1].split(",")
            for (c in 1...nCols - 1) {
                var value = Num.fromString(row[c - 1])
                if (value > 0) lst.add(value)
                if (value == 1) {
                    startRow = r
                    startCol = c
                }
                grid[r][c] = value
            }
        }
    }
    Sort.quick(lst)
    clues = lst
    if (solve.call(startRow, startCol, 1, 0)) printResult.call(n + 1)
    n = n + 1
}
