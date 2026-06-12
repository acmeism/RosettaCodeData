# bt_transform.py by Xing216
from math import factorial
from itertools import islice
from sys import setrecursionlimit
setrecursionlimit(1000000)
def gen_one_followed_by_zeros():
    yield 1
    while True:
        yield 0
def gen_ones():
    while True:
        yield 1
def gen_alternating_signs():
    s = 1
    while True:
        yield s
        s *= -1
def gen_primes():
    """Code by David Eppstein, UC Irvine, 28 Feb 2002 http://code.activestate.com/recipes/117119/"""
    D = {}
    q = 2
    while True:
        if q not in D:
            yield q
            D[q * q] = [q]
        else:
            for p in D[q]:
                D.setdefault(p + q, []).append(p)
            del D[q]
        q += 1
def gen_fibonacci():
    a=0
    b=1
    while True:
        yield b
        a,b= b,a+b
def gen_factorials():
    f = 0
    while True:
        yield factorial(f)
        f += 1
def compressed(n):
    strn = str(n)
    return f"{strn[:20]}...{strn[-20:]} ({len(strn)} digits)"
def boustrophedon(a):
    # Copied from the Wren Solution
    k = len(a)
    cache = [None] * k
    for i in range(k): cache[i] = [0] * k
    b = [0] * k
    b[0] = a[0]
    def T(k,n):
        if n == 0: return a[k]
        if cache[k][n] > 0: return cache[k][n]
        cache[k][n] = T(k,n-1) + T(k-1,k-n)
        return cache[k][n]
    for n in range(1,k):
        b[n] = T(n,n)
    return b
funcs = {"One followed by an infinite series of zeros:":gen_one_followed_by_zeros,
         "Infinite sequence of ones:": gen_ones,
         "Alternating 1, -1, 1, -1:": gen_alternating_signs,
         "Sequence of prime numbers:": gen_primes,
         "Sequence of Fibonacci numbers:": gen_fibonacci,
         "Sequence of factorial numbers:": gen_factorials}
for title, func in funcs.items():
    x = list(islice(func(), 1000))
    y = boustrophedon(x)
    print(title)
    print(y[:15])
    print(f"1000th element: {compressed(y[-1])}\n")
