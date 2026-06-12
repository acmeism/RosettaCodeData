#!/usr/bin/python

from math import log

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True


if __name__ == '__main__':
    Euler = 0.57721566490153286
    m = 0
    for x in range(2, 10_000_000):
        if isPrime(x):
            m += log(1-(1/x)) + (1/x)

    print("MM =", Euler + m)
