#!/usr/bin/python

def reverse(n):
    u = 0
    while n:
        u = 10 * u + n % 10
        n = int(n / 10)
    return u

c = 0
for n in range(1, 200):
    u = reverse(n)
    s = True

    for d in range (1, n):
        if n % d == 0:
            b = reverse(d)
            if u % b != 0:
                s = False
    if s:
        c = c + 1
        print(n, end='\t')

print("\nEncontrados ", c, "divisores especiales.")
