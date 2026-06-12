#!/usr/bin/python3

def isPrime(n):
    for i in range(2, int(n**0.5) + 1):
        if n % i == 0:
            return False
    return True

def reverse(text):
    return text[::-1]

inicio = 2
final = 499
cont = 0

for i in range(inicio, final + 1):
    hexi = hex(i)[2:]  # Convert to hexadecimal and remove '0x' prefix

    if isPrime(i) and hexi == reverse(hexi):
        cont += 1
        print(f"{hexi}  ", end='')

print(f"\nEncontrados {cont} primos palindrómicos entre {inicio} y {final}")
