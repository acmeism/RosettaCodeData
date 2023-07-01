from itertools import count
from pprint import pformat
import re
import heapq


def pal_part_gen(odd=True):
    for i in count(1):
        fwd = str(i)
        rev = fwd[::-1][1:] if odd else fwd[::-1]
        yield int(fwd + rev)

def pal_ordered_gen():
    yield from heapq.merge(pal_part_gen(odd=True), pal_part_gen(odd=False))

def is_gapful(x):
    return (x % (int(str(x)[0]) * 10 + (x % 10)) == 0)

if __name__ == '__main__':
    start = 100
    for mx, last in [(20, 20), (100, 15), (1_000, 10)]:
        print(f"\nLast {last} of the first {mx} binned-by-last digit "
              f"gapful numbers >= {start}")
        bin = {i: [] for i in range(1, 10)}
        gen = (i for i in pal_ordered_gen() if i >= start and is_gapful(i))
        while any(len(val) < mx for val in bin.values()):
            g = next(gen)
            val = bin[g % 10]
            if len(val) < mx:
                val.append(g)
        b = {k:v[-last:] for k, v in bin.items()}
        txt = pformat(b, width=220)
        print('', re.sub(r"[{},\[\]]", '', txt))
