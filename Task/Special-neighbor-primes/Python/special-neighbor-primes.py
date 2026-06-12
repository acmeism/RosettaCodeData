#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

def nextPrime(n):
    #finds the next prime after n
    if n == 0:
        return 2
    if n < 3:
        return n + 1
    q = n + 2
    while not isPrime(q):
        q += 2
    return q


if __name__ == "__main__":
    for p1 in range(3,100,2):
        p2 = nextPrime(p1)
        if isPrime(p1) and p2 < 100 and isPrime(p1 + p2 - 1):
            print(p1,'\t', p2,'\t', p1 + p2 - 1)
