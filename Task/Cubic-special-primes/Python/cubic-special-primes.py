#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

if __name__ == '__main__':
    p = 2
    n = 1

    print("2",end = " ")
    while True:
        if isPrime(p + n**3):
            p += n**3
            n = 1
            print(p,end = " ")
        else:
            n += 1
        if p + n**3 >= 15000:
            break
