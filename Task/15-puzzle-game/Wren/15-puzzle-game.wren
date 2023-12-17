import "random" for Random
import "./dynamic" for Enum
import "./ioutil" for Input
import "./fmt" for Fmt

var Move = Enum.create("Move", ["up", "down", "right", "left"])

var Rand = Random.new()
var RandMove = Fn.new { Rand.int(4) }

var SolvedBoard = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 0]

var AreEqual = Fn.new { |l1, l2|
    if (l1.count != l2.count) return false
    for (i in 0...l1.count) {
        if (l1[i] != l2[i]) return false
    }
    return true
}

class Puzzle {
    construct new() {
        _board = SolvedBoard.toList
        _empty = 15 // _board[empty] == 0
        _moves = 0
        _quit  = false
        // Could make this configurable, 10 == easy, 50 == normal, 100 == hard
        shuffle(50)
    }

    shuffle(moves) {
        // we use some number of random moves to "shuffle" the board
        var i = 0
        while (i < moves || AreEqual.call(_board, SolvedBoard)) {
            if (doMove(RandMove.call())) i = i + 1
        }
    }

    isValidMove(m) {
        if (m == Move.up)    return [_empty - 4, (_empty/4).floor > 0]
        if (m == Move.down)  return [_empty + 4, (_empty/4).floor < 3]
        if (m == Move.right) return [_empty + 1, _empty % 4 < 3]
        if (m == Move.left)  return [_empty - 1, _empty % 4 > 0]
        Fiber.abort("not reached")
    }

    doMove(m) {
        var i = _empty
        var res = isValidMove(m)
        var j  = res[0]
        var ok = res[1]
        if (ok) {
            _board.swap(i, j)
            _empty = j
            _moves = _moves + 1
        }
        return ok
    }

    play() {
        var instructions = """
Please enter "U", "D", "L", or "R" to move the empty cell
up, down, left, or right. You can also enter "Q" to quit.
Upper or lowercase is accepted and only the first character
is important (i.e. you may enter "up" if you like).
"""
        System.print(instructions)
        System.write("\nStarting board:")
        while (!AreEqual.call(_board, SolvedBoard) && !_quit) {
            System.print("\n%(this)")
            playOneMove()
        }
        if (AreEqual.call(_board, SolvedBoard)) {
            System.print("\n%(this)")
            System.print("You solved the puzzle in %(_moves) moves.")
        }
    }

    playOneMove() {
        while (true) {
            var s = Input.option("Enter move #%(_moves + 1) (U, D, L, R or Q): ", "UuDdLlRrQq")
            var m
            if (s == "U" || s == "u") {
                m = Move.up
            } else if (s == "D" || s == "d") {
                m = Move.down
            } else if (s == "L" || s == "l") {
                m = Move.left
            } else if (s == "R" || s == "r") {
                m = Move.right
            } else if (s == "Q" || s == "q") {
                System.print("Quiting after %(_moves).")
                _quit = true
                return
            }
            if (!doMove(m)) {
                System.print("That is not a valid move at the moment.")
                continue
            }
            return
        }
    }

    toString {
        var buf = ""
        var i = 0
        for (c in _board) {
            if (c == 0) {
                buf = buf + "  ."
            } else {
                buf = buf + Fmt.swrite("$3d", c)
            }
            if (i % 4 == 3) buf = buf + "\n"
            i = i + 1
        }
        return buf
    }
}

var p = Puzzle.new()
p.play()
