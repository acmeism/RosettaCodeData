#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

if __name__ == '__main__':
    n = 600851475143
    j = 3
    while not isPrime(n):
        if n % j == 0:
            n /= j
        j += 2
    print(n);
