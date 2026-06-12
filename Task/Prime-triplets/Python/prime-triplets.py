#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

if __name__ == '__main__':
    for p in range(3, 5499, 2):
        if not isPrime(p+6):
            continue
        if not isPrime(p+2):
            continue
        if not isPrime(p):
            continue
        print(f'[{p} {p+2} {p+6}]')
