/* snake.wren */

import "random" for Random
import "./dynamic" for Enum, Lower

foreign class Window {
    construct initscr() {}

    foreign nodelay(bf)
}

class Ncurses {
    foreign static cbreak()

    foreign static noecho()

    foreign static refresh()

    foreign static getch()

    foreign static mvaddch(y, x, ch)

    foreign static endwin()
}

class C {
    foreign static usleep(usec)
}

var Dir = Enum.create("Dir", ["N", "E", "S", "W"])
var State = Enum.create("State", ["space", "food", "border"])

var w = 80
var h = 40
var board = List.filled(w * h, 0)
var rand = Random.new()
var head
var dir
var quit

// ASCII values
var hash = 35
var at   = 64
var dot  = 46
var spc  = 32

/* negative values denote the snake (a negated time-to-live in given cell) */

// reduce a time-to-live, effectively erasing the tail
var age = Fn.new {
    for (i in 0...w * h) {
        if (board[i] < 0) board[i] = board[i] + 1
    }
}

// put a piece of food at random empty position
var plant = Fn.new {
    var r
    while (true) {
        r = rand.int(w * h)
        if (board[r] = State.space) break
    }
    board[r] = State.food
}

// initialize the board, plant a very first food item
var start = Fn.new {
    for (i in 0...w) board[i] = board[i + (h - 1) * w] = State.border
    for (i in 0...h) board[i * w] = board[i * w + w - 1] = State.border
    head = (w * (h - 1 - h % 2) / 2).floor  // screen center for any h
    board[head] = -5
    dir = Dir.N
    quit = false
    plant.call()
}

var step = Fn.new {
    var len = board[head]
    if (dir == Dir.N) {
        head = head - w
    } else if (dir == Dir.S) {
        head = head + w
    } else if (dir == Dir.W) {
        head = head - 1
    } else if (dir == Dir.E) {
        head =  head + 1
    }

    if (board[head] == State.space) {
        board[head] = len - 1  // keep in mind len is negative
        age.call()
    } else if (board[head] == State.food) {
        board[head] = len - 1
        plant.call()
    } else {
        quit = true
    }
}

var show = Fn.new {
    var symbol = [spc, at, dot]
    for (i in 0...w*h) {
        Ncurses.mvaddch((i/w).floor, i % w, board[i] < 0 ? hash : symbol[board[i]])
    }
    Ncurses.refresh()
}

var initScreen = Fn.new {
    var win = Window.initscr()
    Ncurses.cbreak()
    Ncurses.noecho()
    win.nodelay(true)
}

initScreen.call()
start.call()
while (true) {
    show.call()
    var ch = Ncurses.getch()
    if (ch == Lower.i) {
        dir = Dir.N
    } else if (ch == Lower.j) {
        dir = Dir.W
    } else if (ch == Lower.k) {
        dir = Dir.S
    } else if (ch == Lower.l) {
        dir = Dir.E
    } else if (ch == Lower.q) {
        quit = true
    }
    step.call()
    C.usleep(300 * 1000)  // 300 ms is a reasonable delay
    if (quit) break
}
C.usleep(999 * 1000)
Ncurses.endwin()
