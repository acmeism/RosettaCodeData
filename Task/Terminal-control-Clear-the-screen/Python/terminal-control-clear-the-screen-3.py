from ctypes import *

STD_OUTPUT_HANDLE = -11

class COORD(Structure):
    pass

COORD._fields_ = [("X", c_short), ("Y", c_short)]

class SMALL_RECT(Structure):
    pass

SMALL_RECT._fields_ = [("Left", c_short), ("Top", c_short), ("Right", c_short), ("Bottom", c_short)]

class CONSOLE_SCREEN_BUFFER_INFO(Structure):
    pass

CONSOLE_SCREEN_BUFFER_INFO._fields_ = [
    ("dwSize", COORD),
    ("dwCursorPosition", COORD),
    ("wAttributes", c_ushort),
    ("srWindow", SMALL_RECT),
    ("dwMaximumWindowSize", COORD)
]

def clear_console():
    h = windll.kernel32.GetStdHandle(STD_OUTPUT_HANDLE)

    csbi = CONSOLE_SCREEN_BUFFER_INFO()
    windll.kernel32.GetConsoleScreenBufferInfo(h, pointer(csbi))
    dwConSize = csbi.dwSize.X * csbi.dwSize.Y

    scr = COORD(0, 0)
    windll.kernel32.FillConsoleOutputCharacterA(h, c_char(b" "), dwConSize, scr, pointer(c_ulong()))
    windll.kernel32.FillConsoleOutputAttribute(h, csbi.wAttributes, dwConSize, scr, pointer(c_ulong()))
    windll.kernel32.SetConsoleCursorPosition(h, scr)

clear_console()
