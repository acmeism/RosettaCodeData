#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

def isBackPrime(n):
    if not isPrime(n):
        return False
    m = 0
    while n:
        m *= 10
        m += n % 10
        n //= 10
    return isPrime(m)

if __name__ == '__main__':
    for n in range(2, 499):
        if isBackPrime(n):
            print(n, end=' ');
