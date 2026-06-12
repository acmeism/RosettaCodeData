from itertools import takewhile

seq = (h << 4 | l for h in range(32) for l in range(h & 14 < 9 and 10, 16))

print(*takewhile(lambda n: n < 501, seq))
