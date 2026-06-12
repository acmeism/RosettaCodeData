#!/usr/bin/python

def prime(limite, mostrar):
    global columna
    columna = 0

    for n in range(limite):
        strn = str(n)
        if isPrime(n) and ('123' in str(n)):
            columna += 1
            if mostrar == True:
                print(n, end="  ");
                if columna % 8 == 0:
                    print('')
    return columna


if __name__ == "__main__":
    print("Números primos que contienen 123:")
    limite = 100000
    prime(limite, True)
    print("\n\nEncontrados ", columna, " números primos por debajo de", limite)
    limite = 1000000
    prime(limite, False)
    print("\n\nEncontrados ", columna, " números primos por debajo de", limite)
