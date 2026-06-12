#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True


if __name__ == '__main__':
    print("p        q       pq+2")
    print("-----------------------")
    for p in range(2, 499):
        if not isPrime(p):
            continue
        q = p + 1
        while not isPrime(q):
            q += 1
        if not isPrime(2 + p*q):
            continue
        print(p, "\t", q, "\t", 2+p*q)
