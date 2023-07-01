import "random" for Random
import "/ioutil" for FileUtil
import "/pattern" for Pattern
import "/str" for Str
import "/fmt" for Fmt

var dirs = [ [1, 0], [0, 1], [1, 1], [1, -1], [-1, 0], [0, -1], [-1, -1], [-1,  1] ]
var Rows = 10
var Cols = 10
var gridSize = Rows * Cols
var minWords = 25
var rand = Random.new()

class Grid {
    construct new() {
        _numAttempts = 0
        _cells = List.filled(Rows, null)
        for (i in 0...Rows) _cells[i] = List.filled(Cols, " ")
        _solutions = []
    }

    numAttempts     { _numAttempts }
    numAttempts=(n) { _numAttempts = n }
    cells           { _cells }
    solutions       { _solutions }
}

var readWords = Fn.new { |fileName|
    var maxLen = Rows.max(Cols)
    var p = Pattern.new("=3/l#0%(maxLen-3)/l", Pattern.whole)
    return FileUtil.readLines(fileName)
                 .map   { |l| Str.lower(l.trim()) }
                 .where { |l| p.isMatch(l) }.toList
}

var placeMessage = Fn.new { |grid, msg|
    var p = Pattern.new("/U")
    var msg2 = p.replaceAll(Str.upper(msg), "")
    var messageLen = msg2.count
    if (messageLen >= 1 && messageLen < gridSize) {
        var gapSize = (gridSize / messageLen).floor
        for (i in 0...messageLen) {
            var pos = i * gapSize + rand.int(gapSize)
            grid.cells[(pos / Cols).floor][pos % Cols] = msg2[i]
        }
        return messageLen
    }
    return 0
}

var tryLocation = Fn.new { |grid, word, dir, pos|
    var r = (pos / Cols).floor
    var c = pos % Cols
    var len = word.count

    // check bounds
    if ((dirs[dir][0] == 1 && (len + c) > Cols)  ||
        (dirs[dir][0] == -1 && (len - 1) > c)    ||
        (dirs[dir][1] ==  1 && (len + r) > Rows) ||
        (dirs[dir][1] == -1 && (len - 1) > r)) return 0
    var overlaps = 0

    // check cells
    var rr = r
    var cc = c
    for (i in 0...len) {
        if (grid.cells[rr][cc] != " " && grid.cells[rr][cc] != word[i]) return 0
        cc = cc + dirs[dir][0]
        rr = rr + dirs[dir][1]
    }

    // place
    rr = r
    cc = c
    for (i in 0...len) {
        if (grid.cells[rr][cc] == word[i]) {
            overlaps = overlaps + 1
        } else {
            grid.cells[rr][cc] = word[i]
        }
        if (i < len - 1) {
            cc = cc + dirs[dir][0]
            rr = rr + dirs[dir][1]
        }
    }

    var lettersPlaced = len - overlaps
    if (lettersPlaced > 0) {
        grid.solutions.add(Fmt.swrite("$-10s ($d,$d)($d,$d)", word, c, r, cc, rr))
    }
    return lettersPlaced
}

var tryPlaceWord = Fn.new { |grid, word|
    var randDir = rand.int(dirs.count)
    var randPos = rand.int(gridSize)
    for (d in 0...dirs.count) {
        var dir = (d + randDir) % dirs.count
        for (p in 0...gridSize) {
            var pos = (p + randPos) % gridSize
            var lettersPlaced = tryLocation.call(grid, word, dir, pos)
            if (lettersPlaced > 0) return lettersPlaced
        }
    }
    return 0
}

var createWordSearch = Fn.new { |words|
    var numAttempts = 1
    var grid
    while (numAttempts < 100) {
        var outer = false
        grid = Grid.new()
        var messageLen = placeMessage.call(grid, "Rosetta Code")
        var target = gridSize - messageLen
        var cellsFilled = 0
        rand.shuffle(words)
        for (word in words) {
            cellsFilled = cellsFilled + tryPlaceWord.call(grid, word)
            if (cellsFilled == target) {
                if (grid.solutions.count >= minWords) {
                    grid.numAttempts = numAttempts
                    outer = true
                    break
                }
                // grid is full but we didn't pack enough words, start over
                break
            }
        }
        if (outer) break
        numAttempts = numAttempts + 1
    }
    return grid
}

var printResult = Fn.new { |grid|
    if (grid.numAttempts == 0) {
        System.print("No grid to display")
        return
    }
    var size = grid.solutions.count
    System.print("Attempts: %(grid.numAttempts)")
    System.print("Number of words: %(size)")
    System.print("\n     0  1  2  3  4  5  6  7  8  9")
    for (r in 0...Rows) {
         System.write("\n%(r)   ")
         for (c in 0...Cols) System.write(" %(grid.cells[r][c]) ")
    }
    System.print("\n")
    var i = 0
    while (i < size - 1) {
        System.print("%(grid.solutions[i])   %(grid.solutions[i + 1])")
        i = i + 2
    }
    if (size % 2 == 1) System.print(grid.solutions[size - 1])
}

printResult.call(createWordSearch.call(readWords.call("unixdict.txt")))
