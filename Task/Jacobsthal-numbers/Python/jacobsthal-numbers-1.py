#!/usr/bin/python
from math import floor, pow

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

def odd(n):
    return n and 1 != 0

def jacobsthal(n):
    return floor((pow(2,n)+odd(n))/3)

def jacobsthal_lucas(n):
    return int(pow(2,n)+pow(-1,n))

def jacobsthal_oblong(n):
    return jacobsthal(n)*jacobsthal(n+1)


if __name__ == '__main__':
    print("First 30 Jacobsthal numbers:")
    for j in range(0, 30):
        print(jacobsthal(j), end="  ")

    print("\n\nFirst 30 Jacobsthal-Lucas numbers: ")
    for j in range(0, 30):
        print(jacobsthal_lucas(j), end = '\t')

    print("\n\nFirst 20 Jacobsthal oblong numbers: ")
    for j in range(0, 20):
        print(jacobsthal_oblong(j), end="  ")

    print("\n\nFirst 10 Jacobsthal primes: ")
    for j in range(3, 33):
        if isPrime(jacobsthal(j)):
            print(jacobsthal(j))
