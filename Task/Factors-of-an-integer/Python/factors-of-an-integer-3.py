from math import isqrt
def factor(n):
    factors1, factors2 = [], []
    for x in range(1, isqrt(n)):
        if n % x == 0:
            factors1.append(x)
            factors2.append(n // x)
    x += 1
    if x * x == n:
        factors1.append(x)
    factors1.extend(reversed(factors2))
    return factors1

for i in 45, 53, 64:
    print("%i: factors: %s" % (i, factor(i)))
