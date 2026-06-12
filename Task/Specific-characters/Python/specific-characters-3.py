import regex
from collections import Counter
from typing import Iterable

def grapheme_clusters(s: str) -> list[str]:
    return regex.findall(r"\X", s)

def specific(strings: Iterable[str]) -> Iterable[tuple[list[str], list[str]]]:
    counts = [Counter(grapheme_clusters(s)) for s in strings]

    for counter in counts:
        specific_: list[str] = []
        non_specific: list[str] = []

        for ch, count in counter.items():
            if count == 2 and sum(counter_.get(ch, 0) for counter_ in counts) == 2:
                specific_.append(ch)
            else:
                non_specific.append(ch)

        yield specific_, non_specific


if __name__ == "__main__":
    EXAMPLE = [
        "ahwiueshaiu",
        "ajxxfioaaf",
        "ajrdsfroiwr",
        "AА🇧🇬ΑAS🤔ää☃☃̂☃o🇬🇧ö🤔👨‍👩‍👧‍👧",
    ]

    for s, (special_chars, non_special_chars) in zip(EXAMPLE, specific(EXAMPLE)):
        print(s)
        print(f"  {len(special_chars)} special characters ({','.join(special_chars)})")
        print(
            f"  {len(non_special_chars)} non-special characters ({','.join(non_special_chars)})\n"
        )
