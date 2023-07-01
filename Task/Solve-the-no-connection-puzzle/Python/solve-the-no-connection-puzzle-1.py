from __future__ import print_function
from itertools import permutations
from enum import Enum

A, B, C, D, E, F, G, H = Enum('Peg', 'A, B, C, D, E, F, G, H')

connections = ((A, C), (A, D), (A, E),
               (B, D), (B, E), (B, F),
               (G, C), (G, D), (G, E),
               (H, D), (H, E), (H, F),
               (C, D), (D, E), (E, F))


def ok(conn, perm):
    """Connected numbers ok?"""
    this, that = (c.value - 1 for c in conn)
    return abs(perm[this] - perm[that]) != 1


def solve():
    return [perm for perm in permutations(range(1, 9))
            if all(ok(conn, perm) for conn in connections)]


if __name__ == '__main__':
    solutions = solve()
    print("A, B, C, D, E, F, G, H =", ', '.join(str(i) for i in solutions[0]))
