import re
from typing import Iterator

RE_VOWELS = re.compile(r"[aeiou]", re.I)
RE_SPLIT = re.compile(r"(\W+)")


def pig_latin_word(word: str) -> str:
    match = RE_VOWELS.search(word)

    if match is None:
        return word

    index = match.start()

    if index == 0:
        return word + "way"

    return word[index:] + word[:index] + "ay"


def pig_latin_words(sentence: str) -> Iterator[str]:
    for word in RE_SPLIT.split(sentence):
        if word and word[0].isupper():
            yield pig_latin_word(word).capitalize()
        else:
            yield pig_latin_word(word)


def pig_latin_sentence(sentence: str) -> str:
    return "".join(pig_latin_words(sentence))


TEST_CASES = [
    "",
    " ",
    "123456!",
    "Stop! In the name of Wuv!",
    "pig  latin",
    "rosetta  code",
    "the quick brown fox jumps over the lazy dog",
    "pig",
    "black",
    "a",
    "open",
    "hello world",
    "Hello, World!",
    "gypsy",
    "o'hare O'HARE o’hare don't",
]

if __name__ == "__main__":
    for case in TEST_CASES:
        print(f"{case!r:<45} -> {pig_latin_sentence(case)!r}")
