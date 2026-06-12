"""Markov chain text generator. Requires Python >= 3.9."""

import random
from collections import defaultdict
from collections import deque
from itertools import islice
from typing import Iterable
from typing import Iterator
from typing import TypeVar

_T = TypeVar("_T")
RulesT = defaultdict[tuple[str, ...], list[str]]


def train(text: str, window_size: int = 2) -> RulesT:
    rules: RulesT = defaultdict(list)
    for *prefix, suffix in _sliding_window(text.split(" "), window_size + 1):
        rules[tuple(prefix)].append(suffix)
    return rules


def generate_words(rules: RulesT) -> Iterator[str]:
    start: tuple[str, ...] = random.choice(list(rules.keys()))
    state = deque(start, maxlen=len(start))
    yield from state

    while True:
        try:
            word = random.choice(rules[tuple(state)])
            yield word
            state.append(word)
        except KeyError:
            break


def markov_chain_text(text: str, window_size: int = 2, word_count: int = 100) -> str:
    rules = train(text, window_size)
    words = generate_words(rules)
    return " ".join(islice(words, word_count))


def _sliding_window(it: Iterable[_T], n: int) -> Iterator[tuple[_T, ...]]:
    it = iter(it)
    window = deque(islice(it, n - 1), maxlen=n)
    for x in it:
        window.append(x)
        yield tuple(window)


if __name__ == "__main__":
    with open("alice_oz.txt") as fd:
        text = fd.read()

    print(markov_chain_text(text, 3, 100))
