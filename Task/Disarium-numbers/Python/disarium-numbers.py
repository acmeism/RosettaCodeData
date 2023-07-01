#!/usr/bin/python

def isDisarium(n):
    digitos = len(str(n))
    suma = 0
    x = n
    while x != 0:
        suma += (x % 10) ** digitos
        digitos -= 1
        x //= 10
    if suma == n:
        return True
    else:
        return False

if __name__ == '__main__':
    limite = 19
    cont = 0
    n = 0
    print("The first",limite,"Disarium numbers are:")
    while cont < limite:
        if isDisarium(n):
            print(n, end = " ")
            cont += 1
        n += 1
