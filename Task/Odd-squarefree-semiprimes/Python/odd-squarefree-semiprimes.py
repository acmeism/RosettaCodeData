#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True


if __name__ == '__main__':
    for p in range(3, 999):
        if not isPrime(p):
            continue
        for q in range(p+1, 1000//p+1):
            if not isPrime(q):
                continue
            print(p*q, end = " ");
