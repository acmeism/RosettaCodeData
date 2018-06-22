import curses
import time

stdscr = curses.initscr()
curses.curs_set(1)  # visible
time.sleep(2)
curses.curs_set(0)  # invisible
time.sleep(2)
curses.curs_set(1)  # visible
time.sleep(2)
curses.endwin()
