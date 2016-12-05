import sys
import bitio

r = bitio.BitReader(sys.stdin)
while True:
    x = r.readbits(7)
    if not r.read:  # nothing read
        break
    sys.stdout.write(chr(x))
