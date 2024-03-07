"""A Maybe monad. Requires Python >= 3.7 for type hints."""
from __future__ import annotations

from typing import Callable
from typing import Generic
from typing import Optional
from typing import TypeVar
from typing import Union


T = TypeVar("T")
U = TypeVar("U")


class Maybe(Generic[T]):
    def __init__(self, value: Union[Optional[T], Maybe[T]] = None):
        if isinstance(value, Maybe):
            self.value: Optional[T] = value.value
        else:
            self.value = value

    def __rshift__(self, func: Callable[[Optional[T]], Maybe[U]]) -> Maybe[U]:
        return self.bind(func)

    def bind(self, func: Callable[[Optional[T]], Maybe[U]]) -> Maybe[U]:
        return func(self.value)

    def __str__(self):
        return f"{self.__class__.__name__}({self.value!r})"


def plus_one(value: Optional[int]) -> Maybe[int]:
    if value is not None:
        return Maybe(value + 1)
    return Maybe(None)


def currency(value: Optional[int]) -> Maybe[str]:
    if value is not None:
        return Maybe(f"${value}.00")
    return Maybe(None)


if __name__ == "__main__":
    test_cases = [1, 99, None, 4]

    for case in test_cases:
        result = Maybe(case) >> plus_one >> currency

        # or..
        # result = Maybe(case).bind(plus_one).bind(currency)

        print(f"{str(case):<4} -> {result}")
