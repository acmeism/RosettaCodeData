"""Iterables and iterators. Requires Python >= 3.6 for type hints."""
from collections import deque
from typing import Iterable
from typing import Iterator
from typing import Reversible

# array-like
days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
]

# deque is implemented as a doubly linked list
colors = deque(
    [
        "red",
        "yellow",
        "pink",
        "green",
        "purple",
        "orange",
        "blue",
    ]
)


class MyIterable:
    class MyIterator:
        def __init__(self) -> None:
            self._day = -1

        def __iter__(self):
            return self

        def __next__(self):
            if self._day >= 6:
                raise StopIteration

            self._day += 1
            return days[self._day]

    class MyReversedIterator:
        def __init__(self) -> None:
            self._day = 7

        def __iter__(self):
            return self

        def __next__(self):
            if self._day <= 0:
                raise StopIteration

            self._day -= 1
            return days[self._day]

    def __iter__(self):
        return self.MyIterator()

    def __reversed__(self):
        return self.MyReversedIterator()


def print_elements(container: Iterable[object]) -> None:
    for element in container:
        print(element, end=" ")
    print("")  # for trailing newline


def _drop(it: Iterator[object], n: int) -> None:
    """Helper function to advance the iterator at most `n` times."""
    try:
        for _ in range(n):
            next(it)
    except StopIteration:
        pass


def print_first_fourth_fifth(container: Iterable[object]) -> None:
    # Get an iterator from the iterable
    it = iter(container)
    print(next(it), end=" ")
    _drop(it, 2)
    print(next(it), end=" ")
    print(next(it))


def print_reversed_first_fourth_fifth(container: Reversible[object]) -> None:
    # Reverse iterator
    it = reversed(container)
    print(next(it), end=" ")
    _drop(it, 2)
    print(next(it), end=" ")
    print(next(it))


def main() -> None:
    my_iterable = MyIterable()

    print("All elements:")
    print_elements(days)
    print_elements(colors)
    print_elements(my_iterable)

    print("\nFirst, fourth, fifth:")
    print_first_fourth_fifth(days)
    print_first_fourth_fifth(colors)
    print_first_fourth_fifth(my_iterable)

    print("\nLast, fourth to last, fifth to last:")
    print_reversed_first_fourth_fifth(days)
    print_reversed_first_fourth_fifth(colors)
    print_reversed_first_fourth_fifth(my_iterable)


if __name__ == "__main__":
    main()
