#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True


if __name__ == '__main__':
    p = 2
    j = 1
    print(2, end = " ");
    while True:
        while True:
            if isPrime(p + j*j):
                break
            j += 1
        p += j*j
        if p > 16000:
            break
        print(p, end = " ");
        j = 1
