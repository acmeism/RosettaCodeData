import pprint
from collections import Counter
from collections import deque
from itertools import islice
from typing import Iterable


def n_grams(text: str, n: int) -> Iterable[str]:
    """Generate contiguous sequences of _n_ characters from _text_."""
    it = iter(text.upper())
    n_gram = deque(islice(it, n), maxlen=n)
    if len(n_gram) == n:
        yield "".join(n_gram)
    for x in it:
        n_gram.append(x)
        yield "".join(n_gram)


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
