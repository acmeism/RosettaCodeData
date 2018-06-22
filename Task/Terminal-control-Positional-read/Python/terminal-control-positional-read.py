import curses
from random import randint


# Print random text in a 10x10 grid
stdscr = curses.initscr()
for rows in range(10):
    line = ''.join([chr(randint(41, 90)) for i in range(10)])
    stdscr.addstr(line + '\n')

# Read
icol = 3 - 1
irow = 6 - 1
ch = stdscr.instr(irow, icol, 1).decode(encoding="utf-8")

# Show result
stdscr.move(irow, icol + 10)
stdscr.addstr('Character at column 3, row 6 = ' + ch + '\n')
stdscr.getch()

curses.endwin()
