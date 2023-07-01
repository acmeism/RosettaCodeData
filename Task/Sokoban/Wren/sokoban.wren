import "/dynamic" for Tuple
import "/llist" for DLinkedList
import "/set" for Set

var Board = Tuple.create("Board", ["cur", "sol", "x", "y"])

class Sokoban {
    construct new(board) {
        _destBoard = ""
        _currBoard = ""
        _nCols = board[0].count
        _playerX = 0
        _playerY = 0
        for (r in 0...board.count) {
            for (c in 0..._nCols) {
                var ch = board[r][c]
                _destBoard = _destBoard + ((ch != "$" && ch != "@") ? ch : " ")
                _currBoard = _currBoard + ((ch != ".") ? ch : " ")
                if (ch == "@") {
                    _playerX = c
                    _playerY = r
                }
            }
        }
    }

    move(x, y, dx, dy, trialBoard) {
        var newPlayerPos = (y + dy) * _nCols  + x + dx
        if (trialBoard[newPlayerPos] != " ") return ""
        var trial = trialBoard.toList
        trial[y * _nCols + x] = " "
        trial[newPlayerPos] = "@"
        return trial.join()
    }

    push(x, y, dx, dy, trialBoard) {
        var newBoxPos = (y + 2 * dy) * _nCols + x + 2 * dx
        if (trialBoard[newBoxPos] != " ") return ""
        var trial = trialBoard.toList
        trial[y * _nCols + x] = " "
        trial[(y + dy) * _nCols + x + dx] = "@"
        trial[newBoxPos] = "$"
        return trial.join("")
    }

    isSolved(trialBoard) {
        for (i in 0...trialBoard.count) {
            if ((_destBoard[i] == ".") != (trialBoard[i] == "$")) return false
        }
        return true
    }

    solve() {
        var dirLabels = [ ["u", "U"], ["r", "R"], ["d", "D"], ["l", "L"] ]
        var dirs = [ [0, -1], [1, 0], [0, 1], [-1, 0] ]
        var history = Set.new()
        history.add(_currBoard)
        var open = DLinkedList.new()
        open.add(Board.new(_currBoard, "", _playerX, _playerY))

        while (!open.isEmpty) {
            var b = open.removeAt(0)
            for (i in 0...dirs.count) {
                var trial = b.cur
                var dx = dirs[i][0]
                var dy = dirs[i][1]

                // are we standing next to a box ?
                if (trial[(b.y + dy) * _nCols + b.x + dx] == "$") {
                    // can we push it ?
                    trial = push(b.x, b.y, dx, dy, trial)
                    if (!trial.isEmpty) {
                        // or did we already try this one ?
                        if (!history.contains(trial)) {
                            var newSol = b.sol + dirLabels[i][1]
                            if (isSolved(trial)) return newSol
                            open.add(Board.new(trial, newSol, b.x + dx, b.y + dy))
                            history.add(trial)
                        }
                    }
                } else { // otherwise try changing position
                    trial = move(b.x, b.y, dx, dy, trial)
                    if (!trial.isEmpty && !history.contains(trial)) {
                        var newSol = b.sol + dirLabels[i][0]
                        open.add(Board.new(trial, newSol, b.x + dx, b.y + dy))
                        history.add(trial)
                    }
                }
            }
        }
        return "No solution"
    }
}

var level = [
    "#######",
    "#     #",
    "#     #",
    "#. #  #",
    "#. $$ #",
    "#.$$  #",
    "#.#  @#",
    "#######"
]
System.print(level.join("\n"))
System.print()
System.print(Sokoban.new(level).solve())
