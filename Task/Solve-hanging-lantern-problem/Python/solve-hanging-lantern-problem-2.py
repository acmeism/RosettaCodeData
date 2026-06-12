import math
n = int(input())
a = []
tot = 0
for i in range(0, n):
    a.append(int(input()))
    tot += a[i]
res = math.factorial(tot)
for i in range(0, n):
    res /= math.factorial(a[i])
print(int(res))
