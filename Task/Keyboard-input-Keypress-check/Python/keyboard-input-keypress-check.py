#!/usr/bin/env python

import __future__
import sys
if sys.version_info.major < 3:
    import thread as _thread
else:
    import _thread
import time


try:
    from msvcrt import getch  # try to import Windows version
except ImportError:
    def getch():   # define non-Windows version
        import tty, termios
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            ch = sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        return ch

char = None

def keypress():
    global char
    char = getch()

_thread.start_new_thread(keypress, ())

while True:
    if char is not None:
        print("Key pressed is " + char.decode('utf-8'))
        break
    print("Program is running")
    time.sleep(5)
