from sympy import primerange

def strange_triplets(mx: int = 30) -> None:
    primes = list(primerange(0, mx))
    primes3 = set(primerange(0, 3 * mx))
    for i, n in enumerate(primes):
        for j, m in enumerate(primes[i + 1:], i + 1):
            for p in primes[j + 1:]:
                if n + m + p in primes3:
                    yield n, m, p

for c, (n, m, p) in enumerate(strange_triplets(), 1):
    print(f"{c:2}: {n:2}+{m:2}+{p:2} = {n + m + p}")

mx = 1_000
print(f"\nIf n, m, p < {mx:_} finds {sum(1 for _ in strange_triplets(mx)):_}")
