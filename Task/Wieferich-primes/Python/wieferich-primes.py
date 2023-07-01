#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

def isWeiferich(p):
    if not isPrime(p):
        return False
    q = 1
    p2 = p ** 2
    while p > 1:
        q = (2 * q) % p2
        p -= 1
    if q == 1:
        return True
    else:
        return False


if __name__ == '__main__':
    print("Wieferich primes less than 5000: ")
    for i in range(2, 5001):
        if isWeiferich(i):
            print(i)
