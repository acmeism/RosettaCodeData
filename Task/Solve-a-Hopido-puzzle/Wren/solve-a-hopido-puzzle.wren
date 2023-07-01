import "/sort" for Sort
import "/fmt" for Fmt

var board = [
    ".00.00.",
    "0000000",
    "0000000",
    ".00000.",
    "..000..",
    "...0..."
]

var moves = [
    [-3, 0], [0,  3], [ 3, 0], [ 0, -3],
    [ 2, 2], [2, -2], [-2, 2], [-2, -2]
]

var grid = []
var totalToFill = 0

var countNeighbors = Fn.new { |r, c|
    var num = 0
    for (m in moves) if (grid[r + m[1]][c + m[0]] == 0) num = num + 1
    return num
}

var neighbors = Fn.new { |r, c|
    var nbrs = []
    for (m in moves) {
        var x = m[0]
        var y = m[1]
        if (grid[r + y][c + x] == 0) {
            var num = countNeighbors.call(r + y, c + x) - 1
            nbrs.add([r + y, c + x, num])
        }
    }
    return nbrs
}

var solve // recursive
solve = Fn.new { |r, c, count|
    if (count > totalToFill) return true
    var nbrs = neighbors.call(r, c)
    if (nbrs.isEmpty && count != totalToFill) return false
    var cmp = Fn.new { |n1, n2| (n1[2] - n2[2]).sign }
    Sort.insertion(nbrs, cmp) // stable sort
    for (nb in nbrs) {
        var rr = nb[0]
        var cc = nb[1]
        grid[rr][cc] = count
        if (solve.call(rr, cc, count + 1)) return true
        grid[rr][cc] = 0
    }
    return false
}

var printResult = Fn.new {
    for (row in grid) {
        for (i in row) {
            if (i == -1) {
                System.write("   ")
            } else {
                Fmt.write("$2d ", i)
            }
        }
        System.print()
    }
}

var nRows = board.count + 6
var nCols = board[0].count + 6
grid = List.filled(nRows, null)
for (r in 0...nRows) {
    grid[r] = List.filled(nCols, -1)
    for (c in 3...nCols - 3) {
        if (r >= 3 && r < nRows - 3) {
            if (board[r - 3][c - 3] == "0") {
                grid[r][c] = 0
                totalToFill = totalToFill + 1
            }
        }
    }
}
var pos = -1
var r
var c
while (true) {
    while (true) {
        pos = pos + 1
        r = (pos / nCols).truncate
        c = pos % nCols
        if (grid[r][c] != -1) break
    }
    grid[r][c] = 1
    if (solve.call(r, c, 2)) break
    grid[r][c] = 0
    if (pos >= nRows * nCols) break
}
printResult.call()
