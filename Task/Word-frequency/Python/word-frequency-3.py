"""
Word count task from Rosetta Code
http://www.rosettacode.org/wiki/Word_count#Python
"""
from itertools import (groupby,
                       starmap)
from operator import itemgetter
from pathlib import Path
from typing import (Iterable,
                    List,
                    Tuple)


FILEPATH = Path('lesMiserables.txt')
COUNT = 10


def main():
    words_and_counts = most_frequent_words(FILEPATH)
    print(*words_and_counts[:COUNT], sep='\n')


def most_frequent_words(filepath: Path,
                        *,
                        encoding: str = 'utf-8') -> List[Tuple[str, int]]:
    """
    A list of word-frequency pairs sorted by their occurrences.
    The words are read from the given file.
    """
    def word_and_frequency(word: str,
                           words_group: Iterable[str]) -> Tuple[str, int]:
        return word, capacity(words_group)

    file_contents = filepath.read_text(encoding=encoding)
    words = file_contents.lower().split()
    grouped_words = groupby(sorted(words))
    words_and_frequencies = starmap(word_and_frequency, grouped_words)
    return sorted(words_and_frequencies, key=itemgetter(1), reverse=True)


def capacity(iterable: Iterable) -> int:
    """Returns a number of elements in an iterable"""
    return sum(1 for _ in iterable)


if __name__ == '__main__':
    main()
