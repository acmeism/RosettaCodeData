"""Requires Python >= 3.10"""
import operator
from collections import Counter
from itertools import chain
from itertools import groupby
from itertools import pairwise
from typing import Iterable

# Example sequences is saved to data.py
from data import data

GROUPS = [
    (0, 4),
    (4, 8),
    (8, 12),
    (12, 16),
    (16, 25),
    (25, 100),
]


def decreasing_contiguous_subsequences(s: Iterable[int]) -> list[list[int]]:
    subsequences = [t for t in contiguous_subsequences(s) if not is_flat(t)]
    return [trim_plateaus(t) for t in subsequences]


def contiguous_subsequences(s: Iterable[int], op=operator.le) -> Iterable[list[int]]:
    it = iter(s)

    try:
        subsequence = [next(it)]
    except StopIteration:
        return

    for a, b in pairwise(it):
        if op(b, a):
            subsequence.append(b)
        else:
            yield subsequence
            subsequence = [b]


def is_flat(s: list[int]) -> bool:
    return len(s) < 2 or s[0] == s[-1]


def trim_plateaus(s: Iterable[int]) -> list[int]:
    groups = [(k, list(g)) for k, g in groupby(s)]

    if len(groups) < 2:
        return list(s)

    return (
        [groups[0][0]]
        + list(chain.from_iterable(g[1] for g in groups[1:-1]))
        + [groups[-1][0]]
    )


def percentage_change(s: list[int]) -> float:
    return 100 - ((s[-1] / s[0]) * 100)


def subsequence_group(s: list[int]) -> tuple[int, int]:
    change = percentage_change(s)
    for start, end in GROUPS:
        if change >= start and change < end:
            return (start, end)

    raise ValueError(f"subsequence out of range: {change}")


if __name__ == "__main__":
    subsequences = decreasing_contiguous_subsequences(data)
    dist = Counter(subsequence_group(s) for s in subsequences)

    for group in GROUPS:
        print(
            f"{group[0]}% - {group[1]}%".rjust(10),
            f"{dist[group]}",
        )
