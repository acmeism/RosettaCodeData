from pprint import pprint

def matrixMul(A, B):
    TB = list(zip(*B))
    return [[sum(ea * eb for ea, eb in zip(a, b)) for b in TB] for a in A]

def pivotize(m):
    """Creates the pivoting matrix for m."""
    n = len(m)
    ID = [[float(i == j) for i in range(n)] for j in range(n)]
    for j in range(n):
        row = max(range(j, n), key=lambda i: abs(m[i][j]))
        if j != row:
            ID[j], ID[row] = ID[row], ID[j]
    return ID

def lu(A):
    """Decomposes a nxn matrix A by PA=LU and returns L, U and P."""
    n = len(A)
    L = [[0.0] * n for i in range(n)]
    U = [[0.0] * n for i in range(n)]
    P = pivotize(A)
    A2 = matrixMul(P, A)
    for j in range(n):
        L[j][j] = 1.0
        for i in range(j + 1):
            s1 = sum(U[k][j] * L[i][k] for k in range(i))
            U[i][j] = A2[i][j] - s1
        for i in range(j, n):
            s2 = sum(U[k][j] * L[i][k] for k in range(j))
            L[i][j] = (A2[i][j] - s2) / U[j][j]
    return (L, U, P)


a = [[1, 3, 5], [2, 4, 7], [1, 1, 0]]
for part in lu(a):
    pprint(part, width=19)
    print()

print()
b = [[11, 9, 24, 2], [1, 5, 2, 6], [3, 17, 18, 1], [2, 5, 7, 1]]
for part in lu(b):
    pprint(part)
    print()
