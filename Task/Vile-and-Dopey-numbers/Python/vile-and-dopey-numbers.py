import itertools
from typing import Iterator, Callable, List, Tuple

def isVile(n: int) -> bool:
    """
    A number is Vile if its binary representation ends in an even number of zeros.
    Equivalently, count of trailing-zero bits % 2 == 0.
    """
    # n & -n isolates the lowest set bit; its bit_length()‑1 is number of trailing zeros.
    tz: int = (n & -n).bit_length() - 1

    return tz % 2 == 0

def vileVsDopey() -> Iterator[bool]:
    """
    Infinite generator yielding True for Vile, False for Dopey.
    """
    for n in itertools.count(1):
        yield isVile(n)

def takeFirst(countEach: int, predicateSequence: Iterator[bool]) -> Tuple[List[int], List[int]]:
    """
    Walk the boolean sequence and collect the first "countEach" Vile indices and first "countEach" Dopey indices.
    """
    viles: List[int] = []
    dopeys: List[int] = []

    for idx, isV in enumerate(predicateSequence, start=1):
        if isV:
            if len(viles) < countEach:
                viles.append(idx)
        else:
            if len(dopeys) < countEach:
                dopeys.append(idx)
        if len(viles) >= countEach and len(dopeys) >= countEach:
            break

    return viles, dopeys

def printGrid(numbers: List[int], cols: int = 5, label: str = "") -> None:
    if label:
        print(label)
    for i in range(0, len(numbers), cols):
        row: list[int] = numbers[i:i+cols]
        print(" ".join(f"{x:>4}" for x in row))
    print()

def printSummary(maxPower: int = 10, testFunc: Callable[[int], bool] = isVile) -> None:
    """
    Prints a table of cumulative counts up to 2^1, 2^2, ..., 2^maxPower.
    """
    print(
        "|  Up to  | Vile | Dopey |\n"
        "|---------|------|-------|"
    )

    for p in range(1, maxPower+1):
        limit: int = 2 ** p

        vileCount: int = sum(1 for i in range(1, limit+1) if testFunc(i))
        dopeyCount: int = limit - vileCount

        print(f"| {limit:7} | {vileCount:4} | {dopeyCount:5} |")

if __name__ == '__main__':
    v25: list[int]
    d25: list[int]
    v25, d25 = takeFirst(25, vileVsDopey())

    print("First 25 Vile numbers:")
    printGrid(v25)

    print("First 25 Dopey numbers:")
    printGrid(d25)

    printSummary(maxPower=10)
