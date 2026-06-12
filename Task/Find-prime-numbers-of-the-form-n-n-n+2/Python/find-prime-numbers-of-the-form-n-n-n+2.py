#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

if __name__ == '__main__':
    for n in range(1, 200):
        if isPrime(n**3+2):
            print(f'{n}\t{n**3+2}');
