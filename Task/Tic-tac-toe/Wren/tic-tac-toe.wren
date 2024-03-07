import "random" for Random
import "./ioutil" for Input

var r = Random.new()
var b = List.filled(3, null)
for (i in 0..2) b[i] = List.filled(3, 0) // board -> 0: blank; -1: computer; 1: human

var bestI = 0
var bestJ = 0

var checkWinner = Fn.new {
    for (i in 0..2) {
        if (b[i][0] != 0 && b[i][1] == b[i][0] && b[i][2] == b[i][0]) return b[i][0]
        if (b[0][i] != 0 && b[1][i] == b[0][i] && b[2][i] == b[0][i]) return b[0][i]
    }
    if (b[1][1] == 0) return 0
    if (b[1][1] == b[0][0] && b[2][2] == b[0][0]) return b[0][0]
    if (b[1][1] == b[2][0] && b[0][2] == b[1][1]) return b[1][1]
    return 0
}

var showBoard = Fn.new {
    var t = "X O"
    for (i in 0..2) {
        for (j in 0..2) System.write("%(t[b[i][j] + 1]) ")
        System.print()
    }
    System.print("-----")
}

var testMove // recursive
testMove = Fn.new { |value, depth|
    var best = -1
    var changed = 0
    var score = checkWinner.call()
    if (score != 0) return (score == value) ? 1 : -1
    for (i in 0..2) {
        for (j in 0..2) {
            if (b[i][j] == 0) {
                b[i][j] = value
                changed = value
                score = -testMove.call(-value, depth + 1)
                b[i][j] = 0
                if (score > best) {
                    if (depth == 0) {
                        bestI = i
                        bestJ = j
                    }
                    best = score
                }
            }
        }
    }
    return (changed != 0) ? best : 0
}

var game = Fn.new { |u|
    for (i in 0..2) {
        for (j in 0..2) b[i][j] = 0
    }
    System.print("Board postions are numbered so:\n1 2 3\n4 5 6\n7 8 9")
    System.print("You have O, I have X.\n")

    for (k in 0..8) {
        while (u) {
            var move = Input.integer("Your move: ", 1, 9) - 1
            var i = (move/3).floor
            var j = move % 3
            if (b[i][j] == 0) {
                b[i][j] = 1
                break
            }
        }
        if (!u) {
            if (k == 0) { // randomize if computer opens, less boring
                bestI = r.int(1e6) % 3
                bestJ = r.int(1e6) % 3
            } else {
                testMove.call(-1, 0)
            }
            b[bestI][bestJ] = -1
            var myMove = bestI * 3 + bestJ + 1
            System.print("My move: %(myMove)")
        }
        showBoard.call()
        var win = checkWinner.call()
        if (win != 0) return ((win == 1) ? "You win" : "I win") + ".\n\n"
        u = !u
    }
    return "A draw.\n\n"
}

var user = false
while (true) {
    user = !user
    System.write(game.call(user))
    var yn = Input.option("Play again y/n: ", "yYnN")
    if (yn == "n" || yn == "N") return
    System.print()
}
