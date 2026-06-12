import math
szamok = []
limit = 1000

for i in range(1, math.isqrt(limit - 1) + 1, 2):
    num = i*i
    if (num > 99):
        szamok.append(num)

print(szamok)
