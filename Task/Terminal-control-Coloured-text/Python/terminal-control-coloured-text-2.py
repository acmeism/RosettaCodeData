from ctypes import *

windll.Kernel32.GetStdHandle.restype = c_ulong
h = windll.Kernel32.GetStdHandle(c_ulong(0xfffffff5))
#Default CMD colour = 7
def color(colour):
    windll.Kernel32.SetConsoleTextAttribute(h, colour)

for count in range (0, 16):
    color(count)
    print "This Colour Is #" + str(count)

print ""
color(7)
raw_input("holding cmd")
