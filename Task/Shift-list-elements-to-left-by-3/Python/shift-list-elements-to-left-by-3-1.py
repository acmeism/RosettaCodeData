"""Rotate list items.

`rotate_slice` is fastest, followed by `rotate_deque` then `rotate_loop`.

It might still be worth constructing a `deque` if you are doing lots of small
rotations to the same sequence.
"""

from collections import deque
from typing import TypeVar

T = TypeVar("T")


def rotate_loop(l: list[T], n: int) -> list[T]:
    """Rotate items in `l` by popping and appending in a loop.

    Modifies `l` in place and returns `l`.
    """
    for _ in range(n):
        l.append(l.pop(0))
    return l


def rotate_slice(l: list[T], n: int) -> list[T]:
    """Rotate items in `l` by slicing. Supports negative `n`.

    Returns a new list without modifying `l`.
    """
    k = (len(l) + n) % len(l)
    return l[k:] + l[:k]


def rotate_deque(l: list[T], n: int) -> list[T]:
    """Rotate items in `l` using a deque. Supports negative `n`.

    Returns a new list without modifying `l`.
    """
    _l = deque(l)
    _l.rotate(-n)
    return list(_l)


if __name__ == "__main__":
    example_list = [1, 2, 3, 4, 5, 6, 7, 8, 9]

    print(f"rotate_loop({example_list}, 3)  => ", rotate_loop(list(example_list), 3))
    print(f"rotate_slice({example_list}, 3) => ", rotate_slice(example_list, 3))
    print(f"rotate_deque({example_list}, 3) => ", rotate_deque(example_list, 3))
