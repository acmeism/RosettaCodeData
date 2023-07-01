import "random" for Random
import "/ioutil" for Input
import "/str" for Str

var rand = Random.new()
var target = List.filled(3, null)
var board  = List.filled(3, null)
for (i in 0..2) {
    target[i] = List.filled(3, 0)
    board[i]  = List.filled(3, 0)
    for (j in 0..2) target[i][j] = rand.int(2)
}

var flipRow = Fn.new { |r|
    for (c in 0..2) board[r][c] = (board[r][c] == 0) ? 1 : 0
}

var flipCol = Fn.new { |c|
    for (r in 0..2) board[r][c] = (board[r][c] == 0) ? 1 : 0
}

/* starting from the target we make 9 random row or column flips */
var initBoard = Fn.new {
    for (i in 0..2) {
        for (j in 0..2) board[i][j] = target[i][j]
    }
    for (i in 1..9) {
        var rc = rand.int(2)
        if (rc == 0) {
            flipRow.call(rand.int(3))
        } else {
            flipCol.call(rand.int(3))
        }
    }
}

var printBoard = Fn.new { |label, isTarget|
    var a = (isTarget) ? target : board
    System.print("%(label):")
    System.print("  | a b c")
    System.print("---------")
    for (r in 0..2) {
        System.write("%(r + 1) |")
        for (c in 0..2) System.write(" %(a[r][c])")
        System.print()
    }
    System.print()
}

var gameOver = Fn.new {
    for (r in 0..2) {
        for (c in 0..2) if (board[r][c] != target[r][c]) return false
    }
    return true
}

// initialize board and ensure it differs from the target i.e. game not already over!
while (true) {
    initBoard.call()
    if (!gameOver.call()) break
}

printBoard.call("TARGET", true)
printBoard.call("OPENING BOARD", false)
var flips = 0

while (true) {
    var isRow = true
    var n = -1
    var prompt = "Enter row number or column letter to be flipped: "
    var ch = Str.lower(Input.option(prompt, "123abcABC"))
    if (ch == "1" || ch == "2" || ch == "3") {
        n = ch.bytes[0] - 49
    } else {
        isRow = false
        n = ch.bytes[0] - 97
    }
    flips = flips + 1
    if (isRow) flipRow.call(n) else flipCol.call(n)
    var plural = (flips == 1) ? "" : "S"
    printBoard.call("\nBOARD AFTER %(flips) FLIP%(plural)", false)
    if (gameOver.call()) break
}

var plural = (flips == 1) ? "" : "s"
System.print("You've succeeded in %(flips) flip%(plural)")
