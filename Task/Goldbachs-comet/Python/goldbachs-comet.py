from matplotlib.pyplot import scatter, show
from sympy import isprime

def g(n):
    assert n > 2 and n % 2 == 0, 'n in goldbach function g(n) must be even'
    count = 0
    for i in range(1, n//2 + 1):
        if isprime(i) and isprime(n - i):
            count += 1
    return count

print('The first 100 G numbers are:')

col = 1
for n in range(4, 204, 2):
    print(str(g(n)).ljust(4), end = '\n' if (col % 10 == 0) else '')
    col += 1

print('\nThe value of G(1000000) is', g(1_000_000))

x = range(4, 4002, 2)
y = [g(i) for i in x]
colors = [["red", "blue", "green"][(i // 2) % 3] for i in x]
scatter([i // 2 for i in x], y, marker='.', color = colors)
show()
