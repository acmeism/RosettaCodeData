from collections import deque
from itertools import count
from itertools import islice
from pprint import pprint
from typing import Iterable
from typing import Iterator
from typing import TypeVar


def prime_factors(n: int) -> Iterator[int]:
    """Return the prime factors of 'n' in order using a wheel with basis [2, 3, 5].

    Translation of `primeFactors` from https://rosettacode.org/wiki/Category_talk:Wren-math.
    """
    if n < 2:
        return

    inc = [4, 2, 4, 2, 4, 6, 2, 6]

    while n % 2 == 0:
        yield 2
        n //= 2

    while n % 3 == 0:
        yield 3
        n //= 3

    while n % 5 == 0:
        yield 5
        n //= 5

    k = 7
    i = 0

    while k * k <= n:
        if n % k == 0:
            yield k
            n //= k
        else:
            k += inc[i]
            i = (i + 1) % 8

    if n > 1:
        yield n


_T = TypeVar("_T")


def sliding_window(it: Iterable[_T], n: int) -> Iterator[tuple[_T, ...]]:
    it = iter(it)
    window = deque(islice(it, n - 1), maxlen=n)
    for x in it:
        window.append(x)
        yield tuple(window)


def ruth_aaron_numbers_factors() -> Iterator[int]:
    for (i, a), (_, b) in sliding_window(
        ((n, sum(prime_factors(n))) for n in count(2)), 2
    ):
        if a == b:
            yield i


def ruth_aaron_numbers_divisors() -> Iterator[int]:
    for (i, a), (_, b) in sliding_window(
        ((n, sum(set(prime_factors(n)))) for n in count(2)), 2
    ):
        if a == b:
            yield i


def ruth_aaron_triples_factors() -> Iterator[int]:
    for (i, a), (_, b), (_, c) in sliding_window(
        ((n, sum(prime_factors(n))) for n in count(2)), 3
    ):
        if a == b == c:
            yield i


def ruth_aaron_triples_divisors() -> Iterator[int]:
    for (i, a), (_, b), (_, c) in sliding_window(
        ((n, sum(set(prime_factors(n)))) for n in count(2)), 3
    ):
        if a == b == c:
            yield i


if __name__ == "__main__":
    print("First 30 Ruth-Aaron numbers (factors):")
    pprint(list(islice(ruth_aaron_numbers_factors(), 30)), compact=True)
    print("")

    print("First 30 Ruth-Aaron numbers (divisors):")
    pprint(list(islice(ruth_aaron_numbers_divisors(), 30)), compact=True)
    print("")

    print("First Ruth-Aaron triple (factors):")
    print(next(ruth_aaron_triples_factors()))
    print("")

    print("First Ruth-Aaron triple (divisors):")
    print(next(ruth_aaron_triples_divisors()))
