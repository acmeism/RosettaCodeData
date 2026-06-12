"""Find words which contain the most consonants. Requires Python >= 3.7."""
import fileinput
import textwrap

from itertools import groupby
from operator import itemgetter

from typing import Iterable
from typing import List
from typing import Tuple


VOWELS = frozenset("aeiou")


def read_words(path: str, encoding="utf-8") -> Iterable[str]:
    for line in fileinput.input(path, encoding=encoding):
        yield line.strip().lower()


def filter_words(words: Iterable[str]) -> Iterable[Tuple[str, int]]:
    for word in words:
        if len(word) <= 10:
            continue

        consonants = [c for c in word if c not in VOWELS]
        if len(consonants) != len(set(consonants)):
            continue

        yield word, len(consonants)


def group_words(words: Iterable[Tuple[str, int]]) -> Iterable[Tuple[int, List[str]]]:
    for count, group in groupby(
        sorted(words, key=itemgetter(1), reverse=True),
        key=itemgetter(1),
    ):
        yield count, [word for word, _ in group]


def main() -> None:
    all_words = read_words("unixdict.txt")
    words = filter_words(all_words)

    for count, word_group in group_words(words):
        pretty_words = "\n".join(
            textwrap.wrap(" ".join(word_group)),
        )
        plural = "s" if count > 1 else ""
        print(
            f"Found {len(word_group)} word{plural} "
            f"with {count} unique consonants:\n{pretty_words}\n"
        )


if __name__ == "__main__":
    main()
