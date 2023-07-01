import random, sequtils, strutils
import ncurses

randomize()

let win = initscr()
assert not win.isNil, "Unable to initialize."

for y in 0..9:
  mvaddstr(y.cint, 0, newSeqWith(10, sample({'0'..'9', 'a'..'z'})).join())

let row = rand(9).cint
let col = rand(9).cint
let ch = win.mvwinch(row, col)

mvaddstr(row, col + 11, "The character at ($1, $2) is $3.".format(row, col, chr(ch)))
mvaddstr(11, 0, "Press any key to quit.")
refresh()
discard getch()

endwin()
