from itertools import accumulate
from itertools import islice
from itertools import pairwise  # Requires Python>=3.10
from itertools import permutations
from pprint import pprint
from typing import Iterable


def zigzags(n: int) -> Iterable[tuple[int, ...]]:
    return (
        perm
        for perm in permutations(range(1, n + 1))
        if all(x >= y if i % 2 else x <= y for i, (x, y) in enumerate(pairwise(perm)))
    )


def zigzag_permutation_counts() -> Iterable[int]:
    n = 1
    zigzag_numbers = [n]

    while True:
        if n % 2:
            zigzag_numbers = [0] + list(accumulate(zigzag_numbers))
        else:
            zigzag_numbers = list(
                reversed(list(accumulate(reversed(zigzag_numbers))))
            ) + [0]

        yield sum(zigzag_numbers)
        n += 1


if __name__ == "__main__":
    for n in range(1, 6):
        print(f"\nZigZag Permutations for N = {n}:")
        pprint(list(zigzags(n)), compact=True)

    print("\nN     Zigzags\n--------------------------------\n 1    1")
    for i, count in enumerate(islice(zigzag_permutation_counts(), 29)):
        print(f"{i + 2:2d}    {count}")
