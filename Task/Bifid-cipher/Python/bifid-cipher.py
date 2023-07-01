"""Bifid cipher. Requires Python >=3.7."""
import math
import pprint
import string

from itertools import chain
from itertools import zip_longest

from typing import Dict
from typing import Iterable
from typing import Iterator
from typing import Tuple
from typing import TypeVar


T = TypeVar("T")


def group(it: Iterable[T], n: int) -> Iterator[Tuple[T, ...]]:
    """Return the input iterable split in to `n` equal chunks, padded with `None`."""
    return zip_longest(*[iter(it)] * n)


Square = Tuple[Tuple[str, ...], ...]


def polybius_square(alphabet: str) -> Square:
    """Return the given alphabet as a tuple of tuples, representing a Polybius square."""
    return tuple(group(alphabet, math.ceil(math.sqrt(len(alphabet)))))


def polybius_map(square: Square) -> Dict[str, Tuple[int, int]]:
    """Return a reverse lookup for the given Polybius square."""
    return {
        square[i][j]: (i + 1, j + 1)
        for i in range(len(square))
        for j in range(len(square))
    }


def encrypt(message: str, square: Square) -> str:
    """Encrypt a plaintext message using a bifid cipher with the given Polybius square."""
    _map = polybius_map(square)
    return "".join(
        square[x - 1][y - 1]
        for x, y in group(
            chain.from_iterable(zip(*(_map[c] for c in message if c in _map))),
            2,
        )
    )


def decrypt(message: str, square: Square) -> str:
    """Decrypt a ciphertext message using a bifid cipher with the given Polybius square."""
    _map = polybius_map(square)
    return "".join(
        square[x - 1][y - 1]
        for x, y in zip(
            *group(
                chain.from_iterable((_map[c] for c in message if c in _map)),
                len(message),
            )
        )
    )


def normalize(message: str) -> str:
    """Normalize a message for the typical Polybius square."""
    return message.upper().replace("J", "I")


TYPICAL_POLYBIUS_SQUARE = polybius_square(
    alphabet="".join(c for c in string.ascii_uppercase if c != "J")
)


EXAMPLE_POLYBIUS_SQUARE = polybius_square(
    alphabet="BGWKZQPNDSIOAXEFCLUMTHYVR",
)


def main() -> None:
    test_cases = [
        ("ATTACKATDAWN", TYPICAL_POLYBIUS_SQUARE),  # 1
        ("FLEEATONCE", EXAMPLE_POLYBIUS_SQUARE),  # 2
        ("FLEEATONCE", TYPICAL_POLYBIUS_SQUARE),  # 3
        (
            normalize("The invasion will start on the first of January"),
            polybius_square(alphabet="PLAYFIREXMBCDGHKNOQSTUVWZ"),
        ),
        (
            "The invasion will start on the first of January".upper(),
            polybius_square(alphabet=string.ascii_uppercase + string.digits),
        ),
    ]

    for message, square in test_cases:
        pprint.pprint(square)
        print("Message  :", message)
        print("Encrypted:", encrypt(message, square))
        print("Decrypted:", decrypt(encrypt(message, square), square))
        print("")


if __name__ == "__main__":
    main()
