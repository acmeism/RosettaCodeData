"""A List Monad. Requires Python >= 3.7 for type hints."""
from __future__ import annotations
from itertools import chain

from typing import Any
from typing import Callable
from typing import Iterable
from typing import List
from typing import TypeVar


T = TypeVar("T")


class MList(List[T]):
    @classmethod
    def unit(cls, value: Iterable[T]) -> MList[T]:
        return cls(value)

    def bind(self, func: Callable[[T], MList[Any]]) -> MList[Any]:
        return MList(chain.from_iterable(map(func, self)))

    def __rshift__(self, func: Callable[[T], MList[Any]]) -> MList[Any]:
        return self.bind(func)


if __name__ == "__main__":
    # Chained int and string functions
    print(
        MList([1, 99, 4])
        .bind(lambda val: MList([val + 1]))
        .bind(lambda val: MList([f"${val}.00"]))
    )

    # Same, but using `>>` as the bind operator.
    print(
        MList([1, 99, 4])
        >> (lambda val: MList([val + 1]))
        >> (lambda val: MList([f"${val}.00"]))
    )

    # Cartesian product of [1..5] and [6..10]
    print(
        MList(range(1, 6)).bind(
            lambda x: MList(range(6, 11)).bind(lambda y: MList([(x, y)]))
        )
    )

    # Pythagorean triples with elements between 1 and 25
    print(
        MList(range(1, 26)).bind(
            lambda x: MList(range(x + 1, 26)).bind(
                lambda y: MList(range(y + 1, 26)).bind(
                    lambda z: MList([(x, y, z)])
                    if x * x + y * y == z * z
                    else MList([])
                )
            )
        )
    )
