#!/usr/bin/python

import math

def rice_encode(n, k = 2, extended = False):
    if extended:
        n = -2 * n -1 if n < 0 else 2*n
    assert n >= 0
    m = 2**k
    q = n//m
    r = n % m
    return '1' * q + format(r, '0{}b'.format(k + 1))

def rice_decode(a, k = 2, extended = False):
    m = 2**k
    q = a.find('0')
    r = int(a[q:], 2)
    i = (q) * m + r
    if extended:
        i = -(i+1)//2 if i%2 else i//2
    return i

print("Base Rice Coding:")
for n in range(11):
    s = rice_encode(n)
    print(f"{n} -> {s} -> {rice_decode(s)}")

print("Extended Rice Coding:")
for n in range(-10, 11):
    s = rice_encode(n, 2, True)
    print(f"{n} -> {s} -> {rice_decode(s, 2, True)}")
