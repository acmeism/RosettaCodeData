import operator
from itertools import (accumulate,
                       repeat)
from pathlib import Path
from typing import (Iterator,
                    List,
                    Tuple)


FILEPATH = Path('days_of_week.txt')


def read_lines(path: Path) -> Iterator[str]:
    with path.open() as file:
        yield from file


def cumulative_letters(word: str) -> Iterator[str]:
    """For a word 'foo' yields 'f', 'fo', 'foo', 'foo', 'foo', ..."""
    yield from accumulate(word, operator.add)
    yield from repeat(word)


def words_cumulative_letters(words: List[str]) -> Iterator[Tuple[str, ...]]:
    """Yields cumulative letters for several words at the same time"""
    yield from zip(*map(cumulative_letters, words))


def longest_string_length(strings: Tuple[str, ...]) -> int:
    return max(map(len, strings))


def min_abbreviation_length(words: List[str]) -> int:
    def are_unique(abbreviations: Tuple[str, ...]) -> bool:
        return len(set(abbreviations)) == len(words)

    unique_abbreviations = filter(are_unique, words_cumulative_letters(words))

    return longest_string_length(next(unique_abbreviations))


def main():
    for line in read_lines(FILEPATH):
        words = line.split()
        if not words:
            print()
            continue

        count = min_abbreviation_length(words)
        print(f'{count} {line}', end='')


if __name__ == '__main__':
    main()
