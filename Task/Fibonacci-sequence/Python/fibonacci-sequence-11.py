F = {0: 0, 1: 1, 2: 1}
def fib(n):
    if n in F:
        return F[n]
    f1 = fib(n // 2 + 1)
    f2 = fib((n - 1) // 2)
    F[n] = (f1 * f1 + f2 * f2 if n & 1 else f1 * f1 - f2 * f2)
    return F[n]
