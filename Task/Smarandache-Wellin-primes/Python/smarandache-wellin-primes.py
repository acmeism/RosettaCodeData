from itertools import islice
from typing import Iterator

import primesieve
from gmpy2 import mpz


def primes() -> Iterator[int]:
    it = primesieve.Iterator()
    while True:
        yield it.next_prime()


def smarandache_wellin_primes() -> Iterator[tuple[str, int, int]]:
    acc: str = ""
    for i, p in enumerate(primes()):
        acc += str(p)
        if mpz(acc).is_prime():
            yield (acc, p, i)


def derived_smarandache_wellin_primes() -> Iterator[tuple[str, int]]:
    freq = [0] * 10
    for i, p in enumerate(primes()):
        for ch in str(p):
            freq[int(ch)] += 1

        concat = "".join(str(j) for j in freq)
        if mpz(concat).is_prime():
            yield (concat, i)


print("The known Smarandache-Wellin primes are:")
for i, (swp, p, ip) in enumerate(islice(smarandache_wellin_primes(), 8)):
    trunc = f"{swp[:20]}...{swp[-20:]}" if len(swp) > 40 else swp
    print(
        f"{i + 1}: index {ip + 1:>4}  digits {len(swp):>4}  last prime {p:>5} -> {trunc} "
    )

print("\nThe first 20 Derived Smarandache-Wellin primes are:")
for i, (dswp, ip) in enumerate(islice(derived_smarandache_wellin_primes(), 20)):
    print(f"{i + 1:>2}: index {ip + 1:>4}  prime {dswp}")
