#!/usr/bin/python3

from math import comb

def moser(n):
    return (n**4 - 6*n**3 + 23*n**2 - 18*n + 24) // 24

def binomial(n, k):
    return comb(n, k) if 0 <= k <= n else 0

def binomial_transform(seq, N):
    result = []
    for n in range(N):
        s = 0
        for k in range(n+1):
            s += binomial(n, k) * seq[k]
        result.append(s)
    return result

def pascals_triangle_partial_sums(N):
    arr = [[0]*N for _ in range(N)]
    for r in range(N):
        arr[r][0] = 1
        for c in range(1, r+1):
            arr[r][c] = arr[r-1][c-1] + arr[r-1][c]
    tri = []
    for r in range(N):
        tri.append(sum(arr[r][:5]))
    return tri

N = 20

print("The first 20 values of Moser's circle problem calculated in different ways:")
print("\nDirect calculation of a 4th order equation:")
print([moser(i) for i in range(1, N+1)])

print("\nUsing a binomial sums:")
print([binomial(i,4) + binomial(i,2) + 1 for i in range(1, N+1)])

print("\nUsing a binomial transform:")
seq = [1]*5 + [0]*(N-5)
print(binomial_transform(seq, N))

print("\nPartial sums of Pascals trianle:")
print(pascals_triangle_partial_sums(N))
