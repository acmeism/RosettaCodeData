#!/usr/bin/python

from math import sqrt

def isGiuga(m):
    n = m
    f = 2
    l = sqrt(n)
    while True:
        if n % f == 0:
            if ((m / f) - 1) % f != 0:
                return False
            n /= f
            if f > n:
                return True
        else:
            f += 1
            if f > l:
                return False


if __name__ == '__main__':
    n = 3
    c = 0
    print("The first 4 Giuga numbers are: ")
    while c < 4:
        if isGiuga(n):
            c += 1
            print(n)
        n += 1
