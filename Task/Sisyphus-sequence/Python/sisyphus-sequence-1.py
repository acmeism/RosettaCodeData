from collections import Counter
from itertools import islice
from typing import Iterable
from typing import Iterator
from typing import Tuple
from typing import TypeVar

import primesieve


def primes() -> Iterator[int]:
    it = primesieve.Iterator()
    while True:
        yield it.next_prime()


def sisyphus() -> Iterator[Tuple[int, int]]:
    prime = primes()
    n = 1
    p = 0
    yield n, p

    while True:
        if n % 2:
            p = next(prime)
            n = n + p
        else:
            n = n // 2
        yield n, p


def consume(it: Iterator[Tuple[int, int]], n) -> Tuple[int, int]:
    next(islice(it, n - 1, n - 1), None)
    return next(it)


T = TypeVar("T")


def batched(it: Iterable[T], n: int) -> Iterable[Tuple[T, ...]]:
    _it = iter(it)
    batch = tuple(islice(_it, n))
    while batch:
        yield batch
        batch = tuple(islice(_it, n))


if __name__ == "__main__":
    it = sisyphus()
    first_100 = list(islice(it, 100))
    print("The first 100 members of the Sisyphus sequence are:")
    for row in batched(first_100, 10):
        print("  ".join(str(n).rjust(3) for n, _ in row))

    print("")

    for interval in [10**x for x in range(3, 9)]:
        n, prime = consume(it, interval - (interval // 10))
        print(f"{interval:11,}th number: {n:13,}   highest prime needed: {prime:11,}")

    print("")

    sisyphus_lt_250 = Counter(n for n, _ in islice(sisyphus(), 10**8) if n < 250)
    print("These numbers under 250 do not occur in the first 100,000,000 terms:")
    print(" ", [n for n in range(1, 250) if n not in sisyphus_lt_250])
    print("")

    most_common = sisyphus_lt_250.most_common(1)[0][1]
    print("These numbers under 250 occur the most in the first 100,000,000 terms:")
    print(
        f"  {[n for n, c in sisyphus_lt_250.items() if c == most_common]} "
        f"all occur {most_common} times."
    )
