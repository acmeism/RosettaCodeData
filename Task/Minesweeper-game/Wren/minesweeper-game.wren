import "./dynamic" for Struct
import "./fmt" for Fmt
import "random" for Random
import "./ioutil" for Input
import "./str" for Str

var Cell = Struct.create("Cell", ["isMine", "display"])

var lMargin = 4
var grid = []
var mineCount = 0
var minesMarked = 0
var isGameOver = false
var rand = Random.new()

var makeGrid = Fn.new { |n, m|
    if ( n <= 0 || m <= 0) Fiber.abort("Grid dimensions must be positive.")
    grid = List.filled(n, null)
    for (i in 0...n) {
        grid[i] = List.filled(m, null)
        for (j in 0...m) grid[i][j] = Cell.new(false, ".")
    }
    var min = (n * m * 0.1).round  // 10% of tiles
    var max = (n * m * 0.2).round  // 20% of tiles
    mineCount = min + rand.int(max - min + 1)
    var rm = mineCount
    while (rm > 0) {
        var x = rand.int(n)
        var y = rand.int(m)
        if (!grid[x][y].isMine) {
            rm = rm - 1
            grid[x][y].isMine = true
        }
    }
    minesMarked = 0
    isGameOver = false
}

var displayGrid = Fn.new { |isEndOfGame|
    if (!isEndOfGame) {
        System.print("Grid has %(mineCount) mine(s), %(minesMarked) mine(s) marked.")
    }
    var margin = " " * lMargin
    System.write("%(margin) ")
    for (i in 1..grid.count) System.write(i)
    System.print()
    System.print("%(margin) %("-" * grid.count)")
    for (y in 0...grid[0].count) {
        Fmt.write("$*d:", lMargin, y+1)
        for (x in 0...grid.count) System.write(grid[x][y].display)
        System.print()
    }
}

var endGame = Fn.new { |msg|
    isGameOver = true
    System.print(msg)
    var ans = Input.option("Another game (y/n)? : ", "ynYN")
    if (ans == "n" || ans == "N") return
    makeGrid.call(6, 4)
    displayGrid.call(false)
}

var resign = Fn.new {
    var found = 0
    for (y in 0...grid[0].count) {
        for (x in 0...grid.count) {
            if (grid[x][y].isMine) {
                if (grid[x][y].display == "?") {
                    grid[x][y].display = "Y"
                    found = found + 1
                } else if (grid[x][y].display != "x") {
                    grid[x][y].display = "N"
                }
            }
        }
    }
    displayGrid.call(true)
    var msg = "You found  %(found), out of %(mineCount) mine(s)."
    endGame.call(msg)
}

var usage = Fn.new {
    System.print("h or ? - this help,")
    System.print("c x y  - clear cell (x,y),")
    System.print("m x y  - marks (toggles) cell (x,y),")
    System.print("n      - start a new game,")
    System.print("q      - quit/resign the game,")
    System.print("where x is the (horizontal) column number and y is the (vertical) row number.\n")
}

var markCell = Fn.new { |x, y|
    if (grid[x][y].display == "?") {
        minesMarked = minesMarked - 1
        grid[x][y].display = "."
    } else if (grid[x][y].display == ".") {
        minesMarked = minesMarked + 1
        grid[x][y].display = "?"
    }
}

var countAdjMines = Fn.new { |x, y|
    var count = 0
    for (j in y-1..y+1) {
        if (j >= 0 && j < grid[0].count) {
            for (i in x-1..x+1) {
                if (i >= 0 && i < grid.count) {
                    if (grid[i][j].isMine) count = count + 1
                }
            }
        }
    }
    return count
}

var clearCell // recursive function
clearCell = Fn.new { |x, y|
    if (x >= 0 && x < grid.count && y >= 0 && y < grid[0].count) {
        if (grid[x][y].display == ".") {
            if (!grid[x][y].isMine) {
                var count = countAdjMines.call(x, y)
                if (count > 0) {
                    grid[x][y].display = String.fromByte(48 + count)
                } else {
                    grid[x][y].display = " "
                    clearCell.call(x+1, y)
                    clearCell.call(x+1, y+1)
                    clearCell.call(x, y+1)
                    clearCell.call(x-1, y+1)
                    clearCell.call(x-1, y)
                    clearCell.call(x-1, y-1)
                    clearCell.call(x, y-1)
                    clearCell.call(x+1, y-1)
                }
            } else {
                grid[x][y].display = "x"
                System.print("Kaboom! You lost!")
                return false
            }
        }
    }
    return true
}

var testForWin = Fn.new {
    var isCleared = false
    if (minesMarked == mineCount) {
        isCleared = true
        for (x in 0...grid.count) {
            for (y in 0...grid[0].count) {
                if (grid[x][y].display == ".") isCleared = false
            }
        }
    }
    if (isCleared) System.print("You won!")
    return isCleared
}

var splitAction = Fn.new { |action|
    var fields = action.split(" ").where{ |s| s != "" }.toList
    if (fields.count != 3) return [0, 0, false]
    var x = Num.fromString(fields[1])
    if (x < 1 || x > grid.count) return [0, 0, false]
    var y = Num.fromString(fields[2])
    if (y < 1 || y > grid[0].count) return [0, 0, false]
    return [x, y, true]
}

usage.call()
makeGrid.call(6, 4)
displayGrid.call(false)
while (!isGameOver) {
    var action = Str.lower(Input.text("\n>", 1))
    var first = action[0]
    if (first == "h" || first == "?") {
        usage.call()
    } else if (first == "n") {
        makeGrid.call(6, 4)
        displayGrid.call(false)
    } else if (first == "c") {
        var res = splitAction.call(action)
        if (!res[2]) continue
        var x  = res[0]
        var y  = res[1]
        if (clearCell.call(x-1, y-1)) {
            displayGrid.call(false)
            if (testForWin.call()) resign.call()
        } else {
            resign.call()
        }
    } else if (first == "m") {
        var res = splitAction.call(action)
        if (!res[2]) continue
        var x  = res[0]
        var y  = res[1]
        markCell.call(x-1, y-1)
        displayGrid.call(false)
        if (testForWin.call()) resign.call()
    } else if (first == "q") {
        resign.call()
    } else {
        System.print("Invalid option, try again")
    }
}
