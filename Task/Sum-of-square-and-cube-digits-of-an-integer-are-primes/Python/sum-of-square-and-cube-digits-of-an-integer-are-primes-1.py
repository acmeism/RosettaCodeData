#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

def digSum(n, b):
    s = 0
    while n:
        s += (n % b)
        n = n // b
    return s

if __name__ == '__main__':
    for n in range(11, 99):
        if isPrime(digSum(n**3, 10)) and isPrime(digSum(n**2, 10)):
            print(n, end = "  ")
