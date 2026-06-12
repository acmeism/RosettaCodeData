#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

if __name__ == "__main__":
    n = 0
    num = 0

    print('The first 20 pairs of numbers whose sum is prime:')
    while True:
        n += 1
        suma = 2*n+1
        if isPrime(suma):
            num += 1
            if num < 21:
                print('{:2}'.format(n), "+", '{:2}'.format(n+1), "=", '{:2}'.format(suma))
            else:
                break
