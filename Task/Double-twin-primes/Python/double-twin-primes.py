#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

if __name__ == "__main__":
    num = 3
    while num <= 1000:
        if isPrime(num):
            if isPrime(num+2):
                if isPrime(num+6):
                    if isPrime(num+8):
                        print(num, num+2, num+6, num+8, sep="\t")
        num += 2
