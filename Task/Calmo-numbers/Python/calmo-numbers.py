#!/usr/bin/python

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

def isCalmo(n):
    limite = pow(n, 0.5)
    cont = 0
    SumD = 0
    SumQ = 0
    k = 0
    q = 0
    d = 2
    while d < limite:
        q = n/d
        if n % d == 0:
            cont += 1
            SumD += d
            SumQ += q
            if cont == 3:
                k += 3
                if not isPrime(SumD):
                    return False
                if not isPrime(SumQ):
                    return False
                cont = 0
                SumD = 0
                SumQ = 0
        d += 1
    if cont != 0 or k == 0:
        return False
    return True


if __name__ == "__main__":
    for n in range(1, 1000-1):
        if isCalmo(n):
            print(n, end=" ");
