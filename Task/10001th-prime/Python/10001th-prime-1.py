#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

def prime(n: int) -> int:
    if n == 1:
        return 2
    p = 3
    pn = 1
    while pn < n:
        if isPrime(p):
            pn += 1
        p += 2
    return p-2

if __name__ == '__main__':
    print(prime(10001))
