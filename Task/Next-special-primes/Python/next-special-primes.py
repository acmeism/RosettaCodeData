#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True


if __name__ == '__main__':
    p = 3
    i = 2

    print("2 3", end = " ");
    while True:
        if isPrime(p + i) == 1:
            p += i
            print(p, end = " ");
        i += 2
        if p + i >= 1050:
            break
