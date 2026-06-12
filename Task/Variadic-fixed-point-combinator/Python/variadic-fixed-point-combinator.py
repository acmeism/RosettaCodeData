Y = lambda a: [(lambda x: lambda: x(Y(a)))(f) for f in a]

even_odd_fix = [
    lambda f: lambda n: n == 0 or f[1]()(n - 1),
    lambda f: lambda n: n != 0 and f[0]()(n - 1),
]

collatz_fix = [
    lambda f: lambda n, d: d if n == 1 else f[(n % 2)+1]()(n, d+1),
    lambda f: lambda n, d: f[0]()(n//2, d),
    lambda f: lambda n, d: f[0]()(3*n+1, d),
]

even_odd = [f() for f in Y(even_odd_fix)]
collatz = Y(collatz_fix)[0]()

for i in range(1, 11):
    e = even_odd[0](i)
    o = even_odd[1](i)
    c = collatz(i, 0)
    print(f'{i :2d}: Even: {e}  Odd: {o}  Collatz: {c}')
