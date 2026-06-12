from itertools import takewhile

def is_prime(x):
    return x > 1 and all(x % d for d in takewhile(lambda n: n * n <= x, primes))

def init_primes(n):
    global primes
    primes = [2]
    for x in range(3, n + 1, 2):
        if is_prime(x): primes.append(x)

def concat(x, y):
    return 10 ** len(str(y)) * x + y

init_primes(99)
print(*sorted(n for x in primes for y in primes if is_prime(n := concat(x, y))))
