#! /usr/bin/env python
import sys
import bitio

r = bitio.BitReader(sys.stdin)
while True:
    x = r.readbits(7)
    if ( r.read == 0 ):
        break
    sys.stdout.write(chr(x))
