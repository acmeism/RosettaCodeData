import "./sort" for Sort
import "./fmt" for Fmt

var board = []
var given = []
var start = []

var setUp = Fn.new { |input|
    var nRows = input.count
    var puzzle = List.filled(nRows, null)
    for (i in 0...nRows) puzzle[i] = input[i].split(" ")
    var nCols = puzzle[0].count
    var list = []
    board = List.filled(nRows+2, null)
    for (i in 0...board.count) board[i] = List.filled(nCols+2, -1)
    for (r in 0...nRows) {
        var row = puzzle[r]
        for (c in 0...nCols) {
            var cell = row[c]
            if (cell == "_") {
                board[r + 1][c + 1] = 0
            } else if (cell != ".") {
                var value = Num.fromString(cell)
                board[r + 1][c + 1] = value
                list.add(value)
                if (value == 1) start = [r + 1, c + 1]
            }
        }
    }
    Sort.quick(list)
    given = list
}

var solve // recursive
solve = Fn.new { |r, c, n, next|
    if (n > given[-1]) return true
    var back = board[r][c]
    if (back != 0 && back != n) return false
    if (back == 0 && given[next] == n) return false
    var next2 = next
    if (back == n) next2 = next2 + 1
    board[r][c] = n
    for (i in -1..1) {
        for (j in -1..1) if (solve.call(r + i, c + j, n + 1, next2)) return true
    }
    board[r][c] = back
    return false
}

var printBoard = Fn.new {
    for (row in board) {
        for (c in row) {
            if (c == -1) {
                System.write(" . ")
            } else if (c > 0) {
                Fmt.write("$2d ", c)
            } else {
                System.write("__ ")
            }
        }
        System.print()
    }
}

var input = [
    "_ 33 35 _ _ . . .",
    "_ _ 24 22 _ . . .",
    "_ _ _ 21 _ _ . .",
    "_ 26 _ 13 40 11 . .",
    "27 _ _ _ 9 _ 1 .",
    ". . _ _ 18 _ _ .",
    ". . . . _ 7 _ _",
    ". . . . . . 5 _"
]
setUp.call(input)
printBoard.call()
System.print("\nFound:")
solve.call(start[0], start[1], 1, 0)
printBoard.call()
