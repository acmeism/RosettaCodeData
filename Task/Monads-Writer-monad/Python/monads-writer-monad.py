"""A Writer Monad. Requires Python >= 3.7 for type hints."""
from __future__ import annotations

import functools
import math
import os

from typing import Callable
from typing import Generic
from typing import List
from typing import TypeVar
from typing import Union


T = TypeVar("T")
U = TypeVar("U")


class Writer(Generic[T]):
    def __init__(self, value: Union[T, Writer[T]], *msgs: str):
        if isinstance(value, Writer):
            self.value: T = value.value
            self.msgs: List[str] = value.msgs + list(msgs)
        else:
            self.value = value
            self.msgs = list(f"{msg}: {self.value}" for msg in msgs)

    def bind(self, func: Callable[[T], Writer[U]]) -> Writer[U]:
        writer = func(self.value)
        return Writer(writer, *self.msgs)

    def __rshift__(self, func: Callable[[T], Writer[U]]) -> Writer[U]:
        return self.bind(func)

    def __str__(self):
        return f"{self.value}\n{os.linesep.join(reversed(self.msgs))}"

    def __repr__(self):
        return f"Writer({self.value}, \"{', '.join(reversed(self.msgs))}\")"


def lift(func: Callable[[T], U], msg: str) -> Callable[[T], Writer[U]]:
    """Return a writer monad version of the simple function `func`."""

    @functools.wraps(func)
    def wrapped(value: T) -> Writer[U]:
        return Writer(func(value), msg)

    return wrapped


if __name__ == "__main__":
    square_root = lift(math.sqrt, "square root")

    add_one: Callable[[Union[int, float]], Writer[Union[int, float]]] = lift(
        lambda x: x + 1, "add one"
    )

    half: Callable[[Union[int, float]], Writer[float]] = lift(
        lambda x: x / 2, "div two"
    )

    print(Writer(5, "initial") >> square_root >> add_one >> half)
