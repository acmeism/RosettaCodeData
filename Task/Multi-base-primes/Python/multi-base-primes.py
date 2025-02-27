import timeit
from collections import deque

from sympy import isprime


def digits(num: int):
    digits = deque()

    while num > 0:
        digits.appendleft(num % 10)
        num //= 10

    return digits


def all_digits_are_less(dig: list[int], b: int):
    for d in dig:
        if d >= b:
            return False

    return True


def eval_poly(coeffs: list[int], x: int):
    y = 0

    for pv in coeffs:
        y = y * x + pv

    return y


def max_prime_bases(ndig: int, maxbase: int):
    maxprimebases = [[]]
    nwithbases = [0]
    maxprime = 10 ** (ndig) - 1

    for p in range(int((maxprime + 1) / 10), maxprime + 1):
        dig = digits(p)
        bases = [
            b
            for b in range(2, maxbase + 1)
            if isprime(eval_poly(dig, b)) and all_digits_are_less(dig, b)
        ]

        if len(bases) > len(maxprimebases[0]):
            maxprimebases = [bases]
            nwithbases = [p]

        elif len(bases) == len(maxprimebases[0]):
            maxprimebases.append(bases)
            nwithbases.append(p)

    alen, vlen = len(maxprimebases[0]), len(maxprimebases)

    print(
        "\nThe maximum number of prime valued bases for base 10 numeric strings of length",
        ndig,
        "is",
        f"{alen}.",
        "The base 10 value list of",
        "these" if vlen > 1 else "this",
        "is: ",
    )

    for i in range(len(maxprimebases)):
        print(nwithbases[i], "=>", maxprimebases[i])


def main():
    for n in range(1, 7):
        max_prime_bases(n, 36)


if __name__ == "__main__":
    execution_time = timeit.timeit(main, number=1)
    print(f"Execution time: {execution_time:.6f} seconds")
