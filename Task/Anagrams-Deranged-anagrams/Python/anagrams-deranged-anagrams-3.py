from collections import defaultdict
from itertools import combinations
from pathlib import Path
from typing import (Callable,
                    Dict,
                    Iterable,
                    Iterator,
                    List,
                    Optional,
                    Tuple,
                    TypeVar)

WORDS_FILE = 'unixdict.txt'

T1 = TypeVar('T1')
T2 = TypeVar('T2')


def main():
    words = read_words(Path(WORDS_FILE))
    anagram = longest_deranged_anagram(words)
    if anagram:
        print('The longest deranged anagram is: {}, {}'.format(*anagram))
    else:
        print('No deranged anagrams were found')


def read_words(path: Path) -> Iterator[str]:
    """Yields words from file at specified path"""
    with path.open() as file:
        for word in file:
            yield word.strip()


def longest_deranged_anagram(words: Iterable[str]
                             ) -> Optional[Tuple[str, str]]:
    """
    Returns the longest pair of words
    that have no character in the same position
    """
    words_by_lengths = mapping_by_function(len, words)
    decreasing_lengths = sorted(words_by_lengths, reverse=True)
    for length in decreasing_lengths:
        words = words_by_lengths[length]
        anagrams_by_letters = mapping_by_function(sort_str, words)
        for anagrams in anagrams_by_letters.values():
            deranged_pair = next(deranged_word_pairs(anagrams), None)
            if deranged_pair is not None:
                return deranged_pair
    return None


def mapping_by_function(function: Callable[..., T2],
                        iterable: Iterable[T1]) -> Dict[T2, List[T1]]:
    """
    Constructs a dictionary with keys
    obtained from applying an input function
    to items of an iterable,
    and the values filled from the same iterable
    """
    mapping = defaultdict(list)
    for item in iterable:
        mapping[function(item)].append(item)
    return mapping


def sort_str(string: str) -> str:
    """Sorts input string alphabetically"""
    return ''.join(sorted(string))


def deranged_word_pairs(words: Iterable[str]) -> Iterator[Tuple[str, str]]:
    """Yields deranged words from an input list of words"""
    pairs = combinations(words, 2)  # type: Iterator[Tuple[str, str]]
    yield from filter(is_deranged, pairs)


def is_deranged(word_pair: Tuple[str, str]) -> bool:
    """
    Checks if all corresponding letters are different,
    assuming that words have the same length
    """
    return all(a != b for a, b in zip(*word_pair))


if __name__ == '__main__':
    main()
