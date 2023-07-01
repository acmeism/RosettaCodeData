#!/usr/bin/env python
import sys
sys.setrecursionlimit(1025)

def A(k, x1, x2, x3, x4, x5):
    def B():
        nonlocal k
        k -= 1
        return A(k, B, x1, x2, x3, x4)
    return x4() + x5() if k <= 0 else B()

print(A(10, lambda: 1, lambda: -1, lambda: -1, lambda: 1, lambda: 0))
