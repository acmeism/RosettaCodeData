import pprint
from collections import Counter
from typing import Iterable


def n_grams(text: str, n: int) -> Iterable[str]:
    """Generate contiguous sequences of _n_ characters from _text_."""
    if n < 1:
        raise ValueError("n must be an integer > 0")

    text = text.upper()
    return (text[i : (i + n)] for i in range(len(text) - n + 1))


def main() -> None:
    example_text = "Live and let live"

    for n in range(2, 5):
        counts = Counter(n_grams(example_text, n)).most_common()
        print(
            f"{len(counts)} {n}-grams of {example_text!r}:\n",
            pprint.pformat(counts, compact=True),
            end="\n\n",
        )


if __name__ == "__main__":
    main()
