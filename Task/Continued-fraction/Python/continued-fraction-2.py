from decimal import Decimal, getcontext

def calc(fun, n):
    temp = Decimal("0.0")

    for ni in range(n+1, 0, -1):
        (a, b) = fun(ni)
        temp = Decimal(b) / (a + temp)

    return fun(0)[0] + temp

fsqrt2 = lambda n: (2 if n > 0 else 1, 1)

fnapier = lambda n: (n if n > 0 else 2, (n - 1) if n > 1 else 1)

fpi = lambda n: (6 if n > 0 else 3, (2 * n - 1) ** 2)

getcontext().prec = 50
print(calc(fsqrt2, 200))
print(calc(fnapier, 200))
print(calc(fpi, 200))
