from typing import (Callable, List, Any)
from functools import reduce
from operator import mul


def binomialCoefficient(n: int) -> Callable[[int], int]:
    return lambda k: product(enumFromTo(1 + k)(n)) // factorial(n - k)


def enumFromTo(m: int) -> Callable[[int], List[Any]]:
    return lambda n: list(range(m, 1 + n))


def factorial(x: int) -> int:
    return product(enumFromTo(1)(x))


def product(xs: List[Any]) -> int:
    return reduce(mul, xs, 1)


if __name__ == '__main__':
    print(binomialCoefficient(5)(3))
    # k=0 to k=5, where n=5
    print(list(map(binomialCoefficient(5), enumFromTo(0)(5))))
