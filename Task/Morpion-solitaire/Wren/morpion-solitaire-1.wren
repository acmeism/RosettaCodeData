/* Morpion_solitaire.wren */

import "random" for Random
import "./dynamic" for Flags, Struct
import "./fmt" for Conv

class Ncurses {
    foreign static initscr()

    foreign static cbreak()
    foreign static nocbreak()

    foreign static echo()
    foreign static noecho()

    foreign static refresh()

    foreign static getch()

    foreign static mvprintw(y, x, str)

    foreign static timeout(delay)

    foreign static endwin()
}

class C {
    foreign static usleep(usec)
}

// optional settings
var lineLen = 5
var disjoint = 0

var fields = [
    "blank", "occupied", "dirNS", "dirEW",
    "dirNESW", "dirNWSE", "newlyAdded", "current"
]
var State = Flags.create("State", fields, true)

var ofs = [
    [0,  1, State.dirNS],
    [1,  0, State.dirEW],
    [1, -1, State.dirNESW],
    [1,  1, State.dirNWSE]
]

var Move = Struct.create("Move", ["m", "s", "seq", "x", "y"])

var rand = Random.new()

var board
var width
var height

var allocBoard = Fn.new { |w, h|
    var buf = List.filled(h, null)
    for (i in 0...h) buf[i] = List.filled(w, 0)
    return buf
}

var boardSet = Fn.new { |v, x0, y0, x1, y1|
    for (i in y0..y1) {
        for (j in x0..x1) board[i][j] = v
    }
}

var initBoard = Fn.new {
    width = height = 3 * (lineLen - 1)
    board = allocBoard.call(width, height)

    boardSet.call(State.occupied, lineLen-1, 1, 2*lineLen-3, height-2)
    boardSet.call(State.occupied, 1, lineLen-1, width-2, 2*lineLen-3)
    boardSet.call(State.blank, lineLen, 2, 2*lineLen-4, height-3)
    boardSet.call(State.blank, 2, lineLen, width-3, 2*lineLen-4)
}

// -1: expand low index end; 1: expand high index end
var expandBoard = Fn.new { |dw, dh|
    var dw2 = (dw == 0) ? 0 : 1
    var dh2 = (dh == 0) ? 0 : 1
    var nw = width + dw2
    var nh = height + dh2
    var nbuf = allocBoard.call(nw, nh)
    dw = -Conv.btoi(dw < 0)
    dh = -Conv.btoi(dh < 0)
    for (i in 0...nh) {
        if (i + dh < 0 || i + dh >= height) continue
        for (j in 0...nw) {
            if (j + dw < 0 || j + dw >= width) continue
            nbuf[i][j] = board[i+dh][j+dw]
        }
    }
    board = nbuf
    width = nw
    height = nh
}

var showBoard = Fn.new {
    for (i in 0...height) {
        for (j in 0...width){
            var temp
            if (board[i][j] & State.current != 0) {
                temp = "X "
            } else if (board[i][j] & State.newlyAdded != 0) {
                temp = "O "
            } else if (board[i][j] & State.occupied != 0) {
                temp = "+ "
            } else {
                temp = "  "
            }
            Ncurses.mvprintw(i + 1, j * 2, temp)
        }
    }
    Ncurses.refresh()
}

// test if a point can complete a line, or take that point
var testPosition = Fn.new { |y, x, rec|
    if (board[y][x] & State.occupied != 0) return
    for (m in 0..3) {  // 4 directions
        var dx  = ofs[m][0]
        var dy  = ofs[m][1]
        var dir = ofs[m][2]
        var s = 1 - lineLen
        while (s <= 0) { // offset line
            var k = 0
            while (k < lineLen) {
                if (s + k == 0) {
                    k = k + 1
                    continue
                }
                var xx = x + dx * (s + k)
                var yy = y + dy * (s + k)
                if (xx < 0 || xx >= width || yy < 0 || yy >= height) break

                // no piece at position
                if (board[yy][xx] & State.occupied == 0) break

                // this direction taken
                if (board[yy][xx] & dir != 0) break
                k = k + 1
            }
            if (k == lineLen) {
                // position ok
                // random integer to even each option's chance of being picked
                rec.seq = rec.seq + 1
                if (rand.int(rec.seq) == 0) {
                    rec.m = m
                    rec.s = s
                    rec.x = x
                    rec.y = y
                }
            }
            s = s + 1
        }
    }
}

var addPiece = Fn.new { |rec|
    var dx  = ofs[rec.m][0]
    var dy  = ofs[rec.m][1]
    var dir = ofs[rec.m][2]
    board[rec.y][rec.x] = board[rec.y][rec.x] | (State.current | State.occupied)
    for (k in 0...lineLen) {
        var xx = rec.x + dx * (k + rec.s)
        var yy = rec.y + dy * (k + rec.s)
        board[yy][xx] = board[yy][xx] | State.newlyAdded
        if (k >= disjoint || k < lineLen-disjoint) {
            board[yy][xx] = board[yy][xx] | dir
        }
    }
}

var nextMove = Fn.new {
    var rec = Move.new(0, 0, 0, 0, 0)
    // wipe last iteration's new line markers
    for (i in 0...height) {
        for (j in 0...width) {
            board[i][j] = board[i][j] & ~(State.newlyAdded | State.current)
        }
    }
    // randomly pick one of next legal moves
    for (i in 0...height) {
        for (j in 0...width) testPosition.call(i, j, rec)
    }

    // didn't find any move, game over
    if (rec.seq == 0) return false
    addPiece.call(rec)

    if (rec.x == width-1) {
        rec.x = 1
    } else if (rec.x != 0) {
        rec.x = 0
    } else {
        rec.x = -1
    }

    if (rec.y == height-1) {
        rec.y = 1
    } else if (rec.y != 0) {
        rec.y = 0
    } else {
        rec.y = -1
    }

    if (rec.x != 0 || rec.y != 0) expandBoard.call(rec.x, rec.y)
    return true
}

initBoard.call()
Ncurses.initscr()
Ncurses.noecho()
Ncurses.cbreak()
var ch = 0
var move = 0
var waitKey = true
while (true) {
    Ncurses.mvprintw(0, 0, "Move %(move)")
    move = move + 1
    showBoard.call()
    if (!nextMove.call()) {
        nextMove.call()
        showBoard.call()
        break
    }
    if (!waitKey) C.usleep(100000)
    if ((ch = Ncurses.getch()) == 32) {  // spacebar pressed
        waitKey = !waitKey
        if (waitKey) {
            Ncurses.timeout(-1)
        } else {
            Ncurses.timeout(0)
        }
    }
    if (ch == 113) break  // 'q' pressed
}
Ncurses.timeout(-1)
Ncurses.nocbreak()
Ncurses.echo()
Ncurses.endwin()
