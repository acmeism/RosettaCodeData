n, G = 5, 5 # KNAPSACK 0-1 DANILIN
N = n + 1 # rextester.com/BCKP19591
a = 2 ** N
L, C, j, q, s, d, e = [1]*n, [1]*n, [1]*n, [0]*a, [0]*a, [0]*a, [""]*a

from random import randint
for i in range(n):
    L[i] = randint(1, 3)
    C[i] = 10+randint(1, 9)
    print(i+1, L[i], C[i])
print()

for h in range(a-1, (a-1)//2, -1):
    b = str(bin(h))
    e[h] = b[3:len(b)]

    for k in range(n):
        j[k] = int(e[h][k])
        q[h] = q[h]+L[k]*j[k]*C[k]
        d[h] = d[h]+L[k]*j[k]

    if d[h] <= G:
        print(e[h], G, d[h], q[h])
print()

max, m = 0, 1
for i in range(a):
    if d[i] <= G and q[i] > max:
        max, m = q[i], i
print(d[m], q[m], e[m])
