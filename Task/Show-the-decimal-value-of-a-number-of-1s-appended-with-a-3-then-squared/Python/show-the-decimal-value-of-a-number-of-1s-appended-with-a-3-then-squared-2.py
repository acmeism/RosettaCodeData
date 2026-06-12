#!/usr/bin/python

def make13(n):
    return 10 ** (n + 1) // 9 + 2

for n in map(make13, range(8)):
    print('%9d%16d' % (n, n * n))
