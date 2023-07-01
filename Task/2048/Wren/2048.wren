import "/dynamic" for Enum, Struct
import "random" for Random
import "/ioutil" for Input
import "/fmt" for Fmt
import "/str" for Str

var MoveDirection = Enum.create("MoveDirection", ["up", "down", "left", "right"])

var Tile = Struct.create("Tile", ["value", "isBlocked"])

class G2048 {
    construct new() {
        _isDone  = false
        _isWon   = false
        _isMoved = true
        _score = 0
        _board = List.filled(4, null)
        for (i in 0..3) {
            _board[i] = List.filled(4, null)
            for (j in 0..3) _board[i][j] = Tile.new(0, false)
        }
        _rand = Random.new()
        initializeBoard()
    }

    initializeBoard() {
        for (y in 0..3) {
            for (x in 0..3) _board[x][y] = Tile.new(0, false)
        }
    }

    loop() {
        addTile()
        while (true) {
            if (_isMoved) addTile()
            drawBoard()
            if (_isDone) break
            waitKey()
        }
        var endMessage = _isWon ? "You've made it!" : "Game Over!"
        System.print(endMessage)
    }

    drawBoard() {
        System.print("\e[2J") // clear terminal
        System.print("Score: %(_score)\n")
        for (y in 0..3) {
            System.print("+------+------+------+------+")
            System.write("| ")
            for (x in 0..3) {
                if (_board[x][y].value == 0) {
                    System.write("    ")
                } else {
                    Fmt.write("$-4s", _board[x][y].value)
                }
                System.write(" | ")
            }
            System.print()
        }
        System.print("+------+------+------+------+\n\n")
    }

    waitKey() {
        _isMoved = false
        var input = Str.upper(Input.option("(W) Up (S) Down (A) Left (D) Right: ", "WSADwsad"))
        if (input == "W") {
            move(MoveDirection.up)
        } else if (input == "A") {
            move(MoveDirection.left)
        } else if (input == "S") {
            move(MoveDirection.down)
        } else if (input == "D") {
            move(MoveDirection.right)
        }
        for (y in 0..3) {
            for (x in 0..3) _board[x][y].isBlocked = false
        }
    }

    addTile() {
        for (y in 0..3) {
            for (x in 0..3) {
                if (_board[x][y].value != 0) continue
                var a
                var b
                while (true) {
                    a = _rand.int(4)
                    b = _rand.int(4)
                    if (_board[a][b].value == 0) break
                }
                var r = _rand.float()
                _board[a][b].value = (r > 0.89) ? 4 : 2
                if (canMove()) return
            }
        }
        _isDone = true
    }

    canMove() {
        for (y in 0..3) {
            for (x in 0..3) {
                if (_board[x][y].value == 0) return true
            }
        }

        for (y in 0..3) {
            for (x in 0..3) {
                if (testAdd(x + 1, y, _board[x][y].value) ||
                    testAdd(x - 1, y, _board[x][y].value) ||
                    testAdd(x, y + 1, _board[x][y].value) ||
                    testAdd(x, y - 1, _board[x][y].value)) return true
            }
        }

        return false
    }

    testAdd(x, y, value) {
        if (x < 0 || x > 3 || y < 0 || y > 3) return false
        return _board[x][y].value == value
    }

    moveVertically(x, y, d) {
        if (_board[x][y + d].value != 0 &&
            _board[x][y + d].value == _board[x][y].value &&
            !_board[x][y].isBlocked &&
            !_board[x][y + d].isBlocked) {
            _board[x][y].value = 0
            _board[x][y + d].value = _board[x][y + d].value * 2
            _score = _score + _board[x][y + d].value
            _board[x][y + d].isBlocked = true
            _isMoved = true
        } else if (_board[x][y + d].value == 0  && _board[x][y].value != 0) {
            _board[x][y + d].value = _board[x][y].value
            _board[x][y].value = 0
            _isMoved = true
        }

        if (d > 0) {
            if (y + d < 3) moveVertically(x, y + d, 1)
        } else {
            if (y + d > 0) moveVertically(x, y + d, -1)
        }
    }

    moveHorizontally(x, y, d) {
        if (_board[x + d][y].value != 0 &&
            _board[x + d][y].value == _board[x][y].value &&
            !_board[x + d][y].isBlocked &&
            !_board[x][y].isBlocked) {
            _board[x][y].value = 0
            _board[x + d][y].value = _board[x + d][y].value * 2
            _score = _score + _board[x + d][y].value
            _board[x + d][y].isBlocked = true
            _isMoved = true
        } else if (_board[x + d][y].value == 0  && _board[x][y].value != 0) {
            _board[x + d][y].value = _board[x][y].value
            _board[x][y].value = 0
            _isMoved = true
        }

        if (d > 0) {
            if (x + d < 3) moveHorizontally(x + d, y, 1)
        } else {
            if (x + d > 0) moveHorizontally(x + d, y, -1)
        }
    }

    move(direction) {
        if (direction == MoveDirection.up) {
            for (x in 0..3) {
               for (y in 1..3) {
                    if (_board[x][y].value != 0) moveVertically(x, y, -1)
               }
            }
        } else if (direction == MoveDirection.down) {
            for (x in 0..3) {
                for (y in 2..0) {
                    if (_board[x][y].value != 0) moveVertically(x, y, 1)
                }
            }
        } else if (direction == MoveDirection.left) {
            for (y in 0..3) {
                for (x in 1..3) {
                    if (_board[x][y].value != 0) moveHorizontally(x, y, -1)
                }
            }
        } else if (direction == MoveDirection.right) {
            for (y in 0..3) {
                for (x in 2..0) {
                    if (_board[x][y].value != 0) moveHorizontally(x, y, 1)
                }
            }
        }
    }
}

var runGame  // forward declaration

var checkRestart = Fn.new {
    var input = Str.upper(Input.option("(N) New game (P) Exit: ", "NPnp"))
    if (input == "N") {
        runGame.call()
    } else if (input == "P") return
}

runGame = Fn.new {
    var game = G2048.new()
    game.loop()
    checkRestart.call()
}

runGame.call()
