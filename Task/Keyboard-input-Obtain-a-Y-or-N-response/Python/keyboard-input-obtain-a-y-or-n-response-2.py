#!/usr/bin/env python
# -*- coding: utf-8 -*-
from curses import wrapper
#
#
def main(stdscr):
  # const
  #y = ord("y")
  #n = ord("n")
  while True:
    # keyboard input interceptor|listener
    #window.nodelay(yes)
    # - If yes is 1, getch() will be non-blocking.
    # return char code
    #kb_Inpt = stdscr.getch()
    # return string
    kb_Inpt = stdscr.getkey()
    #if kb_Inpt == (y or n):
    if kb_Inpt.lower() == ('y' or 'n'):
      break
      return None
  #
  return None
#
#*** unit test ***#
if __name__ == "__main__":
  #
  wrapper(main)
