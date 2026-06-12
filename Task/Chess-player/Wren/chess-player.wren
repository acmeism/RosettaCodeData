import "./iterate" for Stepped
import "./fmt" for Fmt
import "./ioutil" for Input, Output
import "./str" for Str

var Board = List.filled(8, null)

// initialize Board
var starting = [
    [-500, -270, -300, -900, -7500, -300, -270, -500],
    [-100, -100, -100, -100,  -100, -100, -100, -100],
    [   0,    0,    0,    0,     0,    0,    0,    0],
    [   0,    0,    0,    0,     0,    0,    0,    0],
    [   0,    0,    0,    0,     0,    0,    0,    0],
    [   0,    0,    0,    0,     0,    0,    0,    0],
    [ 100,  100,  100,  100,   100,  100,  100,  100],
    [ 500,  270,  300,  900,  5000,  300,  270,  500]
]
for (x in 0..7) {
    Board[x] = List.filled(8, 0)
    for (y in 0..7) Board[x][y] = starting[x][y]
}

// best moves
var BestA = List.filled(8, 0)
var BestB = List.filled(8, 0)
var BestX = List.filled(8, 0)
var BestY = List.filled(8, 0)

// current Levels
var Cflag = false
var Level = 0
var MaxLevel = 5
var Score = 0
var End = false

// helper classes
class Terminal {
    static clear() {
        Output.fwrite("\e[2J")
        locate(1, 1)
    }

    static locate(r, c) {
        Output.fwrite("\e[%(r);%(c)H")
    }
}

class Color {
    static set(fore, back) {
        fore = (fore < 8) ? fore + 30 : fore + 82
        back = (back < 8) ? back + 40 : back + 92
        Output.fwrite("\e[%(fore);%(back)m")
    }

    static reset() {
        Output.fwrite("\e[39;49m")
    }
}

class Chess {
    // generate list of moves for bishop
    static bishop(a, b, xx, yy, ndx) {
        var id = Board[b][a].sign

        var f = Fn.new { |x, y|
            // make sure no piece of same color
            if (id != Board[y][x].sign) {
                ndx = ndx + 1
                xx[ndx] = x
                yy[ndx] = y
            }
        }

        // work out diagonal moves in each of four directions
        for (dxy in 1..7) {
            var x = a - dxy
            var y = b + dxy
            // stop if go off the board
            if (x < 0 || x > 7 || y < 0 || y > 7) break
            f.call(x, y)
            // stop when hit a piece
            if (Board[y][x] != 0) break
        }
        for (dxy in 1..7) {
            var x = a + dxy
            var y = b + dxy
            if (x < 0 || x > 7 || y < 0 || y > 7) break
            f.call(x, y)
            if (Board[y][x] != 0) break
        }
        for (dxy in 1..7) {
            var x = a - dxy
            var y = b - dxy
            if (x < 0 || x > 7 || y < 0 || y > 7) break
            f.call(x, y)
            if (Board[y][x] != 0) break
        }
        for (dxy in 1..7) {
            var x = a + dxy
            var y = b - dxy
            if (x < 0 || x > 7 || y < 0 || y > 7) break
            f.call(x, y)
            if (Board[y][x] != 0) break
        }
        return ndx
    }

    // evaluate possible moves
    static evaluate(id, prune) {
        var xx = List.filled(27, 0)
        var yy = List.filled(27, 0)
        Level = Level + 1 // update recursion level
        var bestScore = 10000 * id
        for (b in 7..0) { // loop through each square
            for (a in 7..0) {
                // if square doesn't have right color piece, go to next square
                if (Board[b][a].sign != id) {
                    if (Level == 1) showman(a, b, 0)
                    continue
                }
                if (Level == 1) showman(a, b, 8) // show move currently being tried
                var ndx = 0
                ndx = moveList(a, b, xx, yy, ndx) // get list of moves for current piece
                for (i in Stepped.ascend(0..ndx)) { // loop through each possible move
                    var x = xx[i]
                    var y = yy[i]
                    if (Level == 1) {
                        Terminal.locate(1, 1)
                        Fmt.print("Trying: $c$d-$c$d", 65+a, 8-b, 65+x, 8-y)
                        showman(x, y, 8)
                    }
                    var oldScore = Score
                    var mover = Board[b][a]    // store these locations
                    var target = Board[y][x]   // so we can set the move back
                    makeMove(a, b, x, y)       // make the move so we can evaluate
                    if (Level < MaxLevel) {
                        var p = bestScore - target + id*(8 - (4-x).abs - (4-y).abs)
                        Score = Score + evaluate(-id, p)
                    }
                    // work out score for move
                    Score = Score + target - id*(8 - (4-x).abs - (4-y).abs)
                    if ((id < 0 && Score > bestScore) || (id > 0 && Score < bestScore)) {
                        // update current best score
                        BestA[Level] = a
                        BestB[Level] = b
                        BestX[Level] = x
                        BestY[Level] = y
                        bestScore = Score
                        if ((id < 0 && bestScore >= prune) ||
                            (id > 0 && bestScore <= prune)) {
                            // prune to avoid wasting time
                            Board[b][a] = mover  // restore position prior to modification
                            Board[y][x] = target
                            Score = oldScore
                            if (Level == 1) showman(x, y, 0)
                            if (Level == 1) showman(a, b, 0)
                            Level = Level - 1
                            return bestScore
                        }
                    }
                    Board[b][a] = mover
                    Board[y][x] = target
                    Score = oldScore
                    if (Level == 1) showman(x, y, 0)
                }
                if (Level == 1) showman(a, b, 0)
            }
        }
        Level = Level - 1
        return bestScore
    }

    // determine whether 'in check' or not
    static inCheck() {
        var xx = List.filled(27, 0)
        var yy = List.filled(27, 0)
        var ndx = 0
        for (b in 0..7) {
            for (a in 0..7) {
                if (Board[b][a] >= 0) continue
                ndx = moveList(a, b, xx, yy, ndx)
                for (i in Stepped.ascend(0..ndx)) {
                    var x = xx[i]
                    var y = yy[i]
                    if (Board[y][x] == 5000) {
                        System.print("You are in check!\n\n")
                        return true
                    }
                }
            }
        }
        return false
    }

    // get player move
    static io(a, b, x, y, result) {
        var xx = List.filled(27, 0)
        var yy = List.filled(27, 0)
        Terminal.clear()
        if (a >= 0) {
            if (result < -2500) {
                System.print("I resign")
                End = true
                return
            }
            var piece = Board[y][x]
            makeMove(a, b, x, y)
            // show computer move
            Fmt.print("My move: $c$d-$c$d", 65+a, 8-b, 65+x, 8-y)
            if (piece != 0) {
                System.write("I took your ")
                System.print( (piece == 100)  ? "pawn"   :
                              (piece == 270)  ? "knight" :
                              (piece == 300)  ? "bishop" :
                              (piece == 500)  ? "rook"   :
                              (piece == 900)  ? "queen"  :
                              (piece == 5000) ? "king"   : "")
            }
            inCheck()
        }
        while (true) {
            showbd()
            Terminal.locate(24, 1)
            var inp = Str.upper(Input.text("Your move (ex: E2-E4): "))
            if (inp == "QUIT") {
                Terminal.clear()
                End = true
                return
            }
            // castling, kingside rook
            if (inp == "O-O" || inp == "0-0") {
                if (Cflag || Board[7][7] != 500 ||
                    Board[7][6] != 0 || Board[7, 5] != 0) {
                    Terminal.clear()
                    continue
                }
                Board[7][6] = 5000
                Board[7][4] = 0
                Board[7][5] = 500
                Board[7][7] = 0
                Cflag = true
                return
            }
            // castling, queenside rook
            if (inp == "O-O-O" || inp == "0-0-0") {
                if (Cflag || Board[7][0] != 500 ||
                    Board[7][1] != 0 || Board[7, 2] != 0 || Board[7][3] != 0) {
                    Terminal.clear()
                    continue
                }
                Board[7][2] = 5000
                Board[7][4] = 0
                Board[7][3] = 500
                Board[7][0] = 0
                Cflag = true
                return
            }
            if (inp.count < 5) {
                Terminal.clear()
                continue
            }
            b = 8 - (inp[1].bytes[0] - 48)
            a = inp[0].bytes[0] - 65
            x = inp[3].bytes[0] - 65
            y = 8 - (inp[4].bytes[0] - 48)
            if (b > 7 || b < 0 || a > 7 || a < 0 || x > 7 ||
                x < 0 || y > 7 || y < 0 || Board[b][a] <= 0) {
                Terminal.clear()
                continue
            }
            var ndx = 0
            ndx = moveList(a, b, xx, yy, ndx)
            // validate move
            for (k in Stepped.ascend(0..ndx)) {
                if (x == xx[k] && y == yy[k]) {
                    var mover = Board[b][a]
                    var target = Board[y][x]
                    makeMove(a, b, x, y)
                    Terminal.locate(1, 1)
                    // make sure move out of check
                    if (!inCheck()) return
                    Board[b][a] = mover // otherwise move out of check and reset board
                    Board[y][x] = target
                    Terminal.clear()
                    break
                }
            }
            Terminal.clear()
        }
        return
    }

    // generate list of moves for king
    static king(a, b, xx, yy, ndx) {
        var id = Board[b][a].sign
        // go through each of 8 possible moves, checking for same color and off board
        for (dy in -1..1) {
            if (b + dy < 0 || b + dy > 7) continue
            for (dx in -1..1) {
                if (a + dx < 0 || a + dx > 7) continue
                if (id != Board[b+dy][a+dx].sign) {
                    ndx = ndx + 1
                    xx[ndx] = a + dx
                    yy[ndx] = b + dy
                }
            }
        }
        return ndx
    }

    // generate list of moves for knight
    static knight(a, b, xx, yy, ndx) {
        var id = Board[b][a].sign  // get color

        var f = Fn.new { |x, y|
            // make sure on board
            if (x < 0 || x > 7 || y < 0 || y > 7) return
            // make sure no piece of same color
            if (id != Board[y][x].sign) {
                ndx = ndx + 1
                xx[ndx] = x
                yy[ndx] = y
            }
        }

        // work out each of the knight's eight moves
        f.call(a - 1, b - 2)
        f.call(a - 2, b - 1)
        f.call(a + 1, b - 2)
        f.call(a + 2, b - 1)
        f.call(a - 1, b + 2)
        f.call(a - 2, b + 1)
        f.call(a + 1, b + 2)
        f.call(a + 2, b + 1)
        return ndx
    }

    // make a move on the board
    static makeMove(a, b, x, y) {
        Board[y][x] = Board[b][a] // move piece to target square
        Board[b][a] = 0           // old square now empty
        if (y == 0 && Board[y][x] ==  100) Board[y][x] =  900 // pawn promoted
        if (y == 7 && Board[y][x] == -100) Board[y][x] = -900
    }

    // generate list of moves for current piece
    static moveList(a, b, xx, yy, ndx) {
        var piece = Board[b][a].abs.truncate // get value corresponding to piece
        ndx = -1
        // call proper move listing routine depending on piece
        if (piece == 100) {
            ndx = pawn(a, b, xx, yy, ndx)
        } else if (piece == 270) {
            ndx = knight(a, b, xx, yy, ndx)
        } else if (piece == 300) {
            ndx = bishop(a, b, xx, yy, ndx)
        } else if (piece == 500) {
            ndx = rook(a, b, xx, yy, ndx)
        } else if (piece == 900) {
            ndx = queen(a, b, xx, yy, ndx)
        } else {
            ndx = king(a, b, xx, yy, ndx)
        }
        return ndx
    }

    // generate list of moves for pawn
    static pawn(a, b, xx, yy, ndx) {
        var id = Board[b][a].sign  // get color
        if (a - 1 >= 0 && a - 1 <= 7 && b - id >= 0 && b - id <= 7) {
            // if there's a piece to capture, do so
            if (Board[b-id][a-1].sign == -id) {
                ndx = ndx + 1
                xx[ndx] = a - 1
                yy[ndx] = b - id
            }
        }
        if (a + 1 >= 0 && a + 1 <= 7 && b - id >= 0 && b - id <= 7) {
            if (Board[b-id][a+1].sign == -id) {
                ndx = ndx + 1
                xx[ndx] = a + 1
                yy[ndx] = b - id
            }
        }
        if (a >= 0 && a <= 7 && b - id >= 0 && b - id <= 7) {
           // make sure square is empty
           if (Board[b-id][a] == 0) {
                ndx = ndx + 1
                xx[ndx] = a
                yy[ndx] = b - id
                if ((id < 0 && b == 1) || (id > 0 && b == 6)) {
                    // if it's empty move two squares forward
                    if (Board[b-id-id][a] == 0) {
                        ndx = ndx + 1
                        xx[ndx] = a
                        yy[ndx] = b - 2*id
                    }
                }
            }
        }
        return ndx
    }

    // generate list of moves for queen
    static queen(a, b, xx, yy, ndx) {
        // queen's move = bishop + rook
        ndx = bishop(a, b, xx, yy, ndx)
        ndx = rook(a, b, xx, yy, ndx)
        return ndx
    }

    // generate list of moves for rook
    static rook(a, b, xx, yy, ndx) {
        var id = Board[b][a].sign
        // work out vert/horiz moves in each direction
        for (x in Stepped.descend(a-1..0)) {
            if (id != Board[b][x].sign) {
                // if no piece of same color
                ndx = ndx + 1
                xx[ndx] = x
                yy[ndx] = b
            }
            if (Board[b][x] != 0) break
        }
        for (x in Stepped.ascend(a+1..7)) {
            if (id != Board[b][x].sign) {
                ndx = ndx + 1
                xx[ndx] = x
                yy[ndx] = b
            }
            if (Board[b][x] != 0) break
        }
        for (y in Stepped.descend(b-1..0)) {
            if (id != Board[y][a].sign) {
                ndx = ndx + 1
                xx[ndx] = a
                yy[ndx] = y
            }
            if (Board[y][a] != 0) break
        }
        for (y in Stepped.ascend(b+1..7)) {
            if (id != Board[y][a].sign) {
                ndx = ndx + 1
                xx[ndx] = a
                yy[ndx] = y
            }
            if (Board[y][a] != 0) break
        }
        return ndx
    }

    // show board
    static showbd() {
        Terminal.locate(3, 30)
        Color.set(7, 0)
        System.print("A  B  C  D  E  F  G  H")
        for (k in 0..25) {
            Terminal.locate(4, 28 + k)
            Color.set(3, 0)
            System.print(String.fromCodePoint(0x2584))
        }
        for (b in 0..7) {
            Terminal.locate(2*b + 5, 26)
            Color.set(7, 0)
            System.print(String.fromCodePoint(56 - b))
            Terminal.locate(2*b + 5, 28)
            Color.set(3, 0)
            System.print(String.fromCodePoint(0x2588))
            Terminal.locate(2*b + 6, 28)
            Color.set(3, 0)
            System.print(String.fromCodePoint(0x2588))
            for (a in 0..7) {
                var colour = (((a + b) % 2) != 0) ? 8 : 9
                square(3*a + 31, 2*b + 5, colour)
            }
            Terminal.locate(2*b + 5, 53)
            Color.set(3, 0)
            System.print(String.fromCodePoint(0x2588))
            Terminal.locate(2*b + 6, 53)
            Color.set(3, 0)
            System.print(String.fromCodePoint(0x2588))
            Terminal.locate(2*b + 6, 55)
            Color.set(7, 0)
            System.print(String.fromCodePoint(56 - b))
        }
        for (k in 0..25) {
            Terminal.locate(21, 28 + k)
            Color.set(3, 0)
            System.print(String.fromCodePoint(0x2580))
        }
        Terminal.locate(22, 30)
        Color.set(7, 0)
        System.print("A  B  C  D  E  F  G  H")
        for (b in 0..7) {
            for (a in 0..7) showman(a, b, 0)
        }
        Color.set(7, 0)
    }

    // show piece
    static showman(a, b, flag) {
        var back = (Board[b][a] <= 0) ? 0 : 7
        var fore = 7 - back + flag
        if (Board[b][a] == 0) {
            back = (((a + b) & 1) != 0) ? 8 : 9
            fore = back + (-1) * ((flag > 0) ? -1 : 0)
        }
        var piece = Board[b][a].abs.truncate
        var n = (piece == 0)    ? String.fromCodePoint(0x2588) :
                (piece == 100)  ? "P" :
                (piece == 270)  ? "N" :
                (piece == 300)  ? "B" :
                (piece == 500)  ? "R" :
                (piece == 900)  ? "Q" :
                (piece == 5000) ? "K" :
                (piece == 7500) ? "K" : " "
        Terminal.locate(2*b + 5 - ((Board[b][a] > 0) ? -1 : 0), 3*a + 30)
        Color.set(fore, back)
        System.print(n)
        Terminal.locate(1, 1)
        Color.set(7, 0)
    }

    // display a square
    static square(a, b, c) {
        var mt = String.fromCodePoint(0x2588) * 3
        Terminal.locate(b, a - 2)
        Color.set(c, c)
        System.print(mt)
        Terminal.locate(b + 1, a - 2)
        Color.set(c, c)
        System.print(mt)
        Color.set(7, 0)
    }

    // start a game
    static start() {
        var a = -1
        var b =  0
        var x =  8
        var y =  8
        var result = 0
        while (true) {
            Score = 0
            io(a, b, x, y, result)       // get white's move
            if (End) {
                Color.reset()
                Terminal.clear()
                return
            }
            Terminal.clear()
            showbd()                     // update board to show white's move
            result = evaluate(-1, 10000) // get black's move
            a = BestA[1]                 // start column for black's move
            b = BestB[1]                 // start row for black's move
            x = BestX[1]                 // end column for black's move
            y = BestY[1]                 // end row for black's move
        }
    }
}

Chess.start()
