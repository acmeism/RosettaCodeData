/* Terminal_control_Positional_read.wren */

import "random" for Random

foreign class Window {
    construct initscr() {}

    foreign addstr(str)

    foreign inch(y, x)

    foreign move(y, x)

    foreign refresh()

    foreign getch()

    foreign delwin()
}

class Ncurses {
    foreign static endwin()
}

// initialize curses window
var win = Window.initscr()
if (win == 0) {
    System.print("Failed to initialize ncurses.")
    return
}

// print random text in a 10x10 grid
var rand = Random.new()
for (row in 0..9) {
    var line = (0..9).map{ |d| String.fromByte(rand.int(41, 91)) }.join()
    win.addstr(line + "\n")
}

// read
var col = 3 - 1
var row = 6 - 1
var ch = win.inch(row, col)

// show result
win.move(row, col + 10)
win.addstr("Character at column 3, row 6 = %(ch)")
win.move(11, 0)
win.addstr("Press any key to exit...")

// refresh
win.refresh()

// wait for a keypress
win.getch()

// clean-up
win.delwin()
Ncurses.endwin()
