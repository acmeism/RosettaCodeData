import os
from collections import Counter
from functools import partial
from itertools import pairwise  # requires Python >= 3.10
from typing import Iterable


def incrementing_counts(word: str, letters: Iterable[str], minimum: int) -> bool:
    counter = Counter({c: 0 for c in letters})
    counter.update(c for c in word if c in letters)
    counts = counter.most_common()
    return (
        all(a[1] - b[1] == 1 for a, b in pairwise(counts)) and counts[-1][1] >= minimum
    )


def display_incrementing_words(
    filename: str,
    words: Iterable[str],
    letters: Iterable[str],
    minimum: int,
) -> None:
    print(
        f"Incrementing counts of {letters} "
        f"in {filename} "
        f"with a minimum count of {minimum}:"
    )

    _func = partial(incrementing_counts, letters=letters, minimum=minimum)
    print(os.linesep.join(filter(_func, words)) or "<none>", "\n")


if __name__ == "__main__":
    with open("unixdict.txt") as fd:
        unix_dict = [line.strip() for line in fd]

    with open("words_alpha.txt") as fd:
        words_alpha = [line.strip() for line in fd]

    test_cases = [
        ("unixdict.txt", unix_dict, ["a", "b", "c"], 1),
        ("unixdict.txt", unix_dict, ["t", "h", "e"], 1),
        ("unixdict.txt", unix_dict, ["c", "i", "o"], 2),
        ("words_alpha.txt", words_alpha, ["a", "b", "c"], 2),
        ("words_alpha.txt", words_alpha, ["t", "h", "e"], 2),
        ("words_alpha.txt", words_alpha, ["c", "i", "o"], 3),
    ]

    for case in test_cases:
        display_incrementing_words(*case)
