"""
Brute force solution for the Perfect Shuffle problem.
See http://oeis.org/A002326 for possible improvements
"""
from functools import partial
from itertools import chain
from operator import eq
from typing import (Callable,
                    Iterable,
                    Iterator,
                    List,
                    TypeVar)

T = TypeVar('T')


def main():
    print("Deck length | Shuffles ")
    for length in (8, 24, 52, 100, 1020, 1024, 10000):
        deck = list(range(length))
        shuffles_needed = spin_number(deck, shuffle)
        print(f"{length:<11} | {shuffles_needed}")


def shuffle(deck: List[T]) -> List[T]:
    """[1, 2, 3, 4] -> [1, 3, 2, 4]"""
    half = len(deck) // 2
    return list(chain.from_iterable(zip(deck[:half], deck[half:])))


def spin_number(source: T,
                function: Callable[[T], T]) -> int:
    """
    Applies given function to the source
    until the result becomes equal to it,
    returns the number of calls
    """
    is_equal_source = partial(eq, source)
    spins = repeat_call(function, source)
    return next_index(is_equal_source,
                      spins,
                      start=1)


def repeat_call(function: Callable[[T], T],
                value: T) -> Iterator[T]:
    """(f, x) -> f(x), f(f(x)), f(f(f(x))), ..."""
    while True:
        value = function(value)
        yield value


def next_index(predicate: Callable[[T], bool],
               iterable: Iterable[T],
               start: int = 0) -> int:
    """
    Returns index of the first element of the iterable
    satisfying given condition
    """
    for index, item in enumerate(iterable, start=start):
        if predicate(item):
            return index


if __name__ == "__main__":
    main()
