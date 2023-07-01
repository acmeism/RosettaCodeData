import functools

from typing import Iterable
from typing import Tuple


@functools.cache
def find_nth(s: str, sub: str, n: int) -> int:
    assert n >= 1
    if n == 1:
        return s.find(sub)
    return s.find(sub, find_nth(s, sub, n - 1) + 1)


def selective_replace(s: str, ops: Iterable[Tuple[int, str, str]]) -> str:
    chars = list(s)
    for n, old, new in ops:
        chars[find_nth(s, old, n)] = new
    return "".join(chars)


print(
    selective_replace(
        "abracadabra",
        [
            (1, "a", "A"),  # the first 'a' with 'A'
            (2, "a", "B"),  # the second 'a' with 'B'
            (4, "a", "C"),  # the fourth 'a' with 'C'
            (5, "a", "D"),  # the fifth 'a' with 'D'
            (1, "b", "E"),  # the first 'b' with 'E'
            (2, "r", "F"),  # the second 'r' with 'F'
        ],
    )
)
