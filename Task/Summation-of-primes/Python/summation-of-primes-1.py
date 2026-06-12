#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

if __name__ == '__main__':
    suma = 2
    n = 1
    for i in range(3, 2000000, 2):
        if isPrime(i):
            suma += i
            n+=1
    print(suma)
