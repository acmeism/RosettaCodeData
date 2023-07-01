from collections import deque
from itertools import dropwhile, islice, takewhile
from textwrap import wrap
from typing import Iterable, Iterator


Digits = str  # Alias for the return type of to_digits()


def esthetic_nums(base: int) -> Iterator[int]:
    """Generate the esthetic number sequence for a given base

    >>> list(islice(esthetic_nums(base=10), 20))
    [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 12, 21, 23, 32, 34, 43, 45, 54, 56, 65]
    """
    queue: deque[tuple[int, int]] = deque()
    queue.extendleft((d, d) for d in range(1, base))
    while True:
        num, lsd = queue.pop()
        yield num
        new_lsds = (d for d in (lsd - 1, lsd + 1) if 0 <= d < base)
        num *= base  # Shift num left one digit
        queue.extendleft((num + d, d) for d in new_lsds)


def to_digits(num: int, base: int) -> Digits:
    """Return a representation of an integer as digits in a given base

    >>> to_digits(0x3def84f0ce, base=16)
    '3def84f0ce'
    """
    digits: list[str] = []
    while num:
        num, d = divmod(num, base)
        digits.append("0123456789abcdef"[d])
    return "".join(reversed(digits)) if digits else "0"


def pprint_it(it: Iterable[str], indent: int = 4, width: int = 80) -> None:
    """Pretty print an iterable which returns strings

    >>> pprint_it(map(str, range(20)), indent=0, width=40)
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
    12, 13, 14, 15, 16, 17, 18, 19
    <BLANKLINE>
    """
    joined = ", ".join(it)
    lines = wrap(joined, width=width - indent)
    for line in lines:
        print(f"{indent*' '}{line}")
    print()


def task_2() -> None:
    nums: Iterator[int]
    for base in range(2, 16 + 1):
        start, stop = 4 * base, 6 * base
        nums = esthetic_nums(base)
        nums = islice(nums, start - 1, stop)  # start and stop are 1-based indices
        print(
            f"Base-{base} esthetic numbers from "
            f"index {start} through index {stop} inclusive:\n"
        )
        pprint_it(to_digits(num, base) for num in nums)


def task_3(lower: int, upper: int, base: int = 10) -> None:
    nums: Iterator[int] = esthetic_nums(base)
    nums = dropwhile(lambda num: num < lower, nums)
    nums = takewhile(lambda num: num <= upper, nums)
    print(
        f"Base-{base} esthetic numbers with "
        f"magnitude between {lower:,} and {upper:,}:\n"
    )
    pprint_it(to_digits(num, base) for num in nums)


if __name__ == "__main__":
    print("======\nTask 2\n======\n")
    task_2()

    print("======\nTask 3\n======\n")
    task_3(1_000, 9_999)

    print("======\nTask 4\n======\n")
    task_3(100_000_000, 130_000_000)
