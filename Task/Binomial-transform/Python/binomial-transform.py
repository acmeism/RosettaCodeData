from math import factorial
from math import pow

from typing import Iterable
from typing import Sequence


def binomial(n: int, k: int) -> int:
    return factorial(n) // (factorial(n - k) * factorial(k))


def binomial_transform(seq: Sequence) -> Iterable[int]:
    for n in range(len(seq)):
        yield sum(binomial(n, k) * seq[k] for k in range(n + 1))


def inverse_binomial_transform(seq: Sequence) -> Iterable[int]:
    for n in range(len(seq)):
        yield int(sum(pow(-1, n - k) * binomial(n, k) * seq[k] for k in range(n + 1)))


test_sequences = {
    "Catalan number sequence": [
        1,
        1,
        2,
        5,
        14,
        42,
        132,
        429,
        1430,
        4862,
        16796,
        58786,
        208012,
        742900,
        2674440,
        9694845,
        35357670,
        129644790,
        477638700,
        1767263190,
    ],
    "Prime flip-flop sequence": [
        0,
        1,
        1,
        0,
        1,
        0,
        1,
        0,
        0,
        0,
        1,
        0,
        1,
        0,
        0,
        0,
        1,
        0,
        1,
        0,
    ],
    "Fibonacci number sequence": [
        0,
        1,
        1,
        2,
        3,
        5,
        8,
        13,
        21,
        34,
        55,
        89,
        144,
        233,
        377,
        610,
        987,
        1597,
        2584,
        4181,
    ],
    "Padovan number sequence": [
        1,
        0,
        0,
        1,
        0,
        1,
        1,
        1,
        2,
        2,
        3,
        4,
        5,
        7,
        9,
        12,
        16,
        21,
        28,
        37,
    ],
}

if __name__ == "__main__":
    import pprint

    for desc, seq in test_sequences.items():
        print(desc + ":")
        pprint.pprint(seq, compact=True, indent=2)
        print("Forward binomial transform:")
        pprint.pprint(list(binomial_transform(seq)), compact=True, indent=2)
        print("Inverse binomial transform:")
        pprint.pprint(list(inverse_binomial_transform(seq)), compact=True, indent=2)
        print("Round trip:")
        pprint.pprint(
            list(inverse_binomial_transform(list(binomial_transform(seq)))),
            compact=True,
            indent=2,
        )
        print()
