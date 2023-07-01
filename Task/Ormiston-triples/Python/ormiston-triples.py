import textwrap

from itertools import pairwise
from typing import Iterator
from typing import List

import primesieve


def primes() -> Iterator[int]:
    it = primesieve.Iterator()
    while True:
        yield it.next_prime()


def triplewise(iterable):
    for (a, _), (b, c) in pairwise(pairwise(iterable)):
        yield a, b, c


def is_anagram(a: int, b: int, c: int) -> bool:
    return sorted(str(a)) == sorted(str(b)) == sorted(str(c))


def up_to_one_billion() -> int:
    count = 0
    for triple in triplewise(primes()):
        if is_anagram(*triple):
            count += 1
        if triple[2] >= 1_000_000_000:
            break
    return count


def up_to_ten_billion() -> int:
    count = 0
    for triple in triplewise(primes()):
        if is_anagram(*triple):
            count += 1
        if triple[2] >= 10_000_000_000:
            break
    return count


def first_25() -> List[int]:
    rv: List[int] = []
    for triple in triplewise(primes()):
        if is_anagram(*triple):
            rv.append(triple[0])
            if len(rv) >= 25:
                break
    return rv


if __name__ == "__main__":
    print("Smallest members of first 25 Ormiston triples:")
    print(textwrap.fill(" ".join(str(i) for i in first_25())), "\n")
    print(up_to_one_billion(), "Ormiston triples before 1,000,000,000")
    print(up_to_ten_billion(), "Ormiston triples before 10,000,000,000")
