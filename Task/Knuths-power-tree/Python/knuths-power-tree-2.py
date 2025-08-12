""" https://rosettacode.org/wiki/Knuth%27s_power_tree """

from typing import List, Dict
from mpmath import mp

# Set decimal precision for mpmath calculations (like Go example 320 bits)
mp.dps = 140

# Global variables
p: Dict[int, int] = {1: 0}
lvl: List[List[int]] = [[1]]


def path(n: int) -> List[int]:
    """ return path to the node with id ''n'' """
    if n == 0:
        return []

    while n not in p:
        q: List[int] = []
        for x in lvl[0]:
            for y in path(x):
                z = x + y
                if z in p:
                    break
                p[z] = x
                q.append(z)
        lvl[0] = q

    r = path(p[n]) + [n]
    return r


def tree_pow(x: float, n: int) -> mp.mpf:
    """ use power tree to compute x ** n """
    r: Dict[int, mp.mpf] = {0: mp.mpf('1'), 1: mp.mpf(str(x))}
    prev = 0
    for i in path(n):
        r[i] = mp.mpf(r[i - prev] * r[prev])
        prev = i
    return r[n]


def show_pow(x: float, n: int) -> None:
    """ print the power calculation """
    print(f"{n}: {path(n)}")
    y = tree_pow(x, n)
    ans = mp.nstr(y, n=100, strip_zeros=True)[
        :-2] if mp.isint(y) else mp.nstr(y, n=10)
    print(f"{mp.nstr(x)} ^ {n} = {ans}\n")


if __name__ == "__main__":
    for expo in range(18):
        show_pow(2, expo)
    show_pow(1.1, 81)
    show_pow(3.0, 191)
