from itertools import combinations
from itertools import product
from random import shuffle
from typing import Iterable
from typing import List
from typing import NamedTuple
from typing import Tuple

NUMBERS = ("one", "two", "three")
SHAPES = ("diamond", "squiggle", "oval")
SHADING = ("solid", "striped", "open")
COLORS = ("red", "green", "purple")


class Card(NamedTuple):
    number: str
    shading: str
    color: str
    shape: str

    def __str__(self) -> str:
        s = " ".join(self)
        if self.number != "one":
            s += "s"
        return s


Cards = List[Card]


def new_deck() -> Cards:
    """Return a new shuffled deck of 81 unique cards."""
    deck = [Card(*features) for features in product(NUMBERS, SHADING, COLORS, SHAPES)]
    shuffle(deck)
    return deck


def deal(deck: Cards, n: int) -> Tuple[Cards, Cards]:
    """Return _n_ cards from the top of the deck and what remains of the deck."""
    return deck[:n], deck[n:]


def is_set(cards: Tuple[Card, Card, Card]) -> bool:
    """Return _True_ if _cards_ forms a set."""
    return (
        same_or_different(c.number for c in cards)
        and same_or_different(c.shape for c in cards)
        and same_or_different(c.shading for c in cards)
        and same_or_different(c.color for c in cards)
    )


def same_or_different(features: Iterable[str]) -> bool:
    """Return _True_ if _features_ are all the same or all different."""
    return len(set(features)) in (1, 3)


def print_sets_from_new_deck(n: int) -> None:
    """Display sets found in _n_ cards dealt from a new shuffled deck."""
    table, _ = deal(new_deck(), n)
    print(f"Cards dealt: {n}\n")
    print("\n".join(str(card) for card in table), end="\n\n")

    sets = [comb for comb in combinations(table, 3) if is_set(comb)]
    print(f"Sets present: {len(sets)}\n")
    for _set in sets:
        print("\n".join(str(card) for card in _set), end="\n\n")

    print("----")


if __name__ == "__main__":
    for n in (4, 8, 12):
        print_sets_from_new_deck(n)
