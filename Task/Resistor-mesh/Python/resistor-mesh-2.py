import sys, copy
from fractions import Fraction

def gauss(a, b):
    n, p = len(a), len(a[0])
    for i in range(n):
        t = abs(a[i][i])
        k = i
        for j in range(i + 1, n):
            if abs(a[j][i]) > t:
                t = abs(a[j][i])
                k = j
        if k != i:
            for j in range(i, n):
                a[i][j], a[k][j] = a[k][j], a[i][j]
            b[i], b[k] = b[k], b[i]
        t = 1/a[i][i]
        for j in range(i + 1, n):
            a[i][j] *= t
        b[i] *= t
        for j in range(i + 1, n):
            t = a[j][i]
            for k in range(i + 1, n):
                a[j][k] -= t*a[i][k]
            b[j] -= t * b[i]
    for i in range(n - 1, -1, -1):
        for j in range(i):
            b[j] -= a[j][i]*b[i]
    return b

def resistor_grid(p, q, ai, aj, bi, bj):
    n = p*q
    I = Fraction(1, 1)
    v = [0*I]*n
    a = [copy.copy(v) for i in range(n)]
    for i in range(p):
        for j in range(q):
            k = i*q + j
            if i == ai and j == aj:
                a[k][k] = I
            else:
                c = 0
                if i + 1 < p:
                    c += 1
                    a[k][k + q] = -1
                if i >= 1:
                    c += 1
                    a[k][k - q] = -1
                if j + 1 < q:
                    c += 1
                    a[k][k + 1] = -1
                if j >= 1:
                    c += 1
                    a[k][k - 1] = -1
                a[k][k] = c*I
    b = [0*I]*n
    k = bi*q + bj
    b[k] = 1
    return gauss(a, b)[k]

def main(arg):
    r = resistor_grid(int(arg[0]), int(arg[1]), int(arg[2]), int(arg[3]), int(arg[4]), int(arg[5]))
    print(r)
    print(float(r))

main(sys.argv[1:])

# Output:
# python grid.py 10 10 1 1 7 6
# 455859137025721/283319837425200
# 1.6089912417307297
