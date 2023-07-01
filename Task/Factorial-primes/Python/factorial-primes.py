from itertools import count
from itertools import islice
from typing import Iterable
from typing import Tuple

import gmpy2


def factorials() -> Iterable[int]:
    fact = 1
    for i in count(1):
        yield fact
        fact *= i


def factorial_primes() -> Iterable[Tuple[int, int, str]]:
    for n, fact in enumerate(factorials()):
        if gmpy2.is_prime(fact - 1):
            yield (n, fact - 1, "-")
        if gmpy2.is_prime(fact + 1):
            yield (n, fact + 1, "+")


def print_factorial_primes(limit=10) -> None:
    print(f"First {limit} factorial primes.")
    for n, fact_prime, op in islice(factorial_primes(), 1, limit + 1):
        s = str(fact_prime)
        if len(s) > 40:
            s = f"{s[:20]}...{s[-20:]} ({len(s)} digits)"
        print(f"{n}! {op} 1 = {s}")


if __name__ == "__main__":
    import sys
    print_factorial_primes(int(sys.argv[1]) if len(sys.argv) > 1 else 10)
