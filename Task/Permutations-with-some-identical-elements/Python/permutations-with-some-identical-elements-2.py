"""Permutations with some identical elements. Requires Python >= 3.7."""
from itertools import chain
from itertools import permutations
from itertools import repeat

from typing import Iterable
from typing import Tuple
from typing import TypeVar

T = TypeVar("T")


def permutations_repeated(
    duplicates: Iterable[int],
    symbols: Iterable[T],
) -> Iterable[Tuple[T, ...]]:
    """Return distinct permutations for `symbols` repeated `duplicates` times."""
    iters = (repeat(sym, dup) for sym, dup in zip(symbols, duplicates))
    return sorted(
        set(
            permutations(
                chain.from_iterable(iters),
            ),
        ),
    )


def main() -> None:
    print(permutations_repeated([2, 3, 1], range(1, 4)))  # 1-based
    print(permutations_repeated([2, 3, 1], range(3)))  # 0-based
    print(permutations_repeated([2, 3, 1], ["A", "B", "C"]))  # letters


if __name__ == "__main__":
    main()
