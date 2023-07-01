import sys
import bitio

o = bitio.BitWriter(sys.stdout)
c = sys.stdin.read(1)
while len(c) > 0:
    o.writebits(ord(c), 7)
    c = sys.stdin.read(1)
o.flush()
