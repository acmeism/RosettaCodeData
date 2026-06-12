from collections import Counter
from typing import Iterable
from typing import Iterator


def equal_abcs(word: str, n: int = 0) -> bool:
    """Return true if the number of a's, b's and c's in _word_ are equal
    and _word_ contains at least _n_ a's.
    """
    counter = Counter(a=0, b=0, c=0)
    counter.update(c for c in word if c in ("a", "b", "c"))
    return len(set(counter.values())) == 1 and counter["a"] >= n


def equal_abc_words(words: Iterable[str], n: int = 2) -> Iterator[str]:
    """Generate words from _words_ where equal_abcs(word, n) is true."""
    return (word for word in words if equal_abcs(word, n))


if __name__ == "__main__":
    # From user input
    word = input("Equal a's, b's and c's in: ")
    print(equal_abcs(word))

    print("")

    # All words from words_alpha.txt that have an equal number of a's, b's and
    # c's and have more than one of each.
    #
    # Assumes https://github.com/dwyl/english-words/blob/master/words_alpha.txt
    # exists in the current working directory.
    with open("words_alpha.txt") as fd:
        words = (line.strip() for line in fd)
        for word in equal_abc_words(words, n=2):
            print(word)
